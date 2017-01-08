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

          json_text = serialize_batch write_events

          position = nil

          request.(path, json_text, expected_version: expected_version) do |request, response|
            telemetry.record :post, Telemetry::Post.new(request, response)

            location = response['Location']
            *, position = URI.parse(location).path.split '/'
            position = position.to_i
          end

          logger.info { "Put event data batch done (StreamName: #{stream_name}, Size: #{write_events.size}, ExpectedVersion: #{expected_version.inspect}, Position: #{position})" }

          position
        end

        def serialize_batch(write_events)
          logger.trace { "Serializing batch (Size: #{write_events.count})" }

          formatted_data = write_events.map &method(:format_event_data)

          json_text = JSON.pretty_generate formatted_data

          logger.debug { "Serialized batch (Size: #{write_events.count})" }
          logger.debug(tag: :data) { json_text }

          json_text
        end

        def format_event_data(event)
          logger.trace { "Formatting event data (Type: #{event.type})" }

          data = {
            'eventId' => uuid.get,
            'eventType' => event.type
          }

          unless event.data.nil? || event.data.empty?
            formatted_data = Casing::Camel.(event.data, symbol_to_string: true)
            data['data'] = formatted_data
          end

          unless event.metadata.nil? || event.metadata.empty?
            formatted_metadata = Casing::Camel.(event.metadata, symbol_to_string: true)
            data['metadata'] = formatted_metadata
          end

          logger.debug { "Formatted event data (Type: #{event.type}, Data: #{data.key? :data}, Metadata: #{data.key? :metadata}" }
          logger.debug(tag: :data) { data.pretty_inspect }

          data
        end

        def stream_path(stream_name)
          "/streams/#{stream_name}"
        end
      end
    end
  end
end
