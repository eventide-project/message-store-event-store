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

        def call(write_event, stream_name, expected_version: nil)
          logger.trace { "Putting event data (StreamName: #{stream_name}, Type #{write_event.type}, ExpectedVersion: #{expected_version.inspect})" }
          logger.trace(tags: [:data, :event_data]) { write_event.pretty_inspect }

          path = stream_path stream_name

          event_store_data = [
            {
              :event_id => uuid.get,
              :event_type => write_event.type,
              :data => write_event.data,
              :metadata => write_event.metadata
            }
          ]

          formatted_data = Casing::Camel.(event_store_data)

          json_text = JSON.pretty_generate formatted_data

          location = nil

          request.(path, json_text, expected_version: expected_version) do |request, response|
            telemetry.record :post, Telemetry::Post.new(request, response)

            location = response['Location']
          end

          _, stream_name, position = URI.parse(location).path.split '/'

          position.to_i
        end

        def stream_path(stream_name)
          "/streams/#{stream_name}"
        end
      end
    end
  end
end
