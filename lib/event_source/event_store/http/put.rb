module EventSource
  module EventStore
    module HTTP
      class Put
        include Log::Dependency

        configure :put

        dependency :request, Request::Post
        dependency :telemetry, ::Telemetry
        dependency :uuid, Identifier::UUID::Random

        def self.build(session: nil)
          instance = new
          Request::Post.configure instance, session: session
          ::Telemetry.configure instance
          Identifier::UUID::Random.configure instance
          instance
        end

        def self.call(write_event, stream_name, expected_version: nil, session: nil)
          instance = build session: session
          instance.(write_event, stream_name, expected_version: expected_version)
        end

        def self.register_telemetry_sink(instance)
          sink = Telemetry::Sink.new
          instance.telemetry.register sink
          sink
        end

        def call(write_events, stream_name, expected_version: nil)
          write_events = Array(write_events)

          logger.trace { "Putting event data batch (StreamName: #{stream_name}, Size: #{write_events.size}, ExpectedVersion: #{expected_version.inspect})" }
          logger.trace(tags: [:data, :event_data]) { write_events.pretty_inspect }

          path = stream_path stream_name

          request_data = write_events.map do |write_event|
            {
              :event_id => uuid.get,
              :event_type => write_event.type,
              :data => write_event.data,
              :metadata => write_event.metadata
            }
          end

          formatted_data = Casing::Camel.(request_data)

          json_text = JSON.pretty_generate formatted_data

          position = nil

          response = request.(path, json_text, expected_version: expected_version) do |request|
            telemetry.record :post, Telemetry::Post.new(request, response)

            location = response['Location']
            _, _, position = URI.parse(location).path.split '/'
            position = location.to_i
          end

          logger.debug { "Put event data batch done (StreamName: #{stream_name}, Size: #{write_events.size}, ExpectedVersion: #{expected_version.inspect}, Position: #{position})" }

          position
        end

        def stream_path(stream_name)
          "/streams/#{stream_name}"
        end
      end
    end
  end
end
