module EventSource
  module EventStore
    module HTTP
      class Put
        include Log::Dependency

        configure :put

        dependency :write, ::EventStore::HTTP::Write

        def self.build(session: nil)
          instance = new
          ::EventStore::HTTP::Write.configure instance, session: session
          instance
        end

        def self.call(write_event, stream_name, expected_version: nil, session: nil)
          instance = build session: session
          instance.(write_event, stream_name, expected_version: expected_version)
        end

        def call(write_events, stream_name, expected_version: nil)
          write_events = Array(write_events)

          logger.trace { "Putting event data (StreamName: #{stream_name}, BatchSize: #{write_events.count}, Types: #{write_events.map(&:type).inspect})" }

          location = write.(
            write_events,
            stream_name,
            expected_version: expected_version
          )

          *, position = location.path.split '/'

          logger.debug { "Put event data done (StreamName: #{stream_name}, BatchSize: #{write_events.count}, Types: #{write_events.map(&:type).inspect}, Position: #{position})" }

          position.to_i
        end
      end
    end
  end
end
