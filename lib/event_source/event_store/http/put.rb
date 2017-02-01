module EventSource
  module EventStore
    module HTTP
      class Put
        include Log::Dependency

        configure :put

        dependency :write, ::EventStore::HTTP::Write

        def self.build(session: nil)
          session ||= Session.build

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

          expected_version = ExpectedVersion.canonize expected_version

          logger.trace { "Putting event data (StreamName: #{stream_name}, BatchSize: #{write_events.count}, Types: #{write_events.map(&:type).inspect}, ExpectedVersion: #{expected_version.inspect})" }

          write_events.each do |write_event|
            write_event.metadata = nil if write_event.metadata&.empty?
          end

          begin
            location = write.(
              write_events,
              stream_name,
              expected_version: expected_version
            )
          rescue ::EventStore::HTTP::Write::ExpectedVersionError => error
            raise ExpectedVersion::Error, error.message
          end

          *, position = location.path.split '/'

          logger.debug { "Put event data done (StreamName: #{stream_name}, BatchSize: #{write_events.count}, Types: #{write_events.map(&:type).inspect}, Position: #{position}, ExpectedVersion: #{expected_version.inspect})" }

          position.to_i
        end

        module Assertions
          def self.extended(put)
            put.write.extend ::EventStore::HTTP::Request::Assertions
          end

          def session?(session, strict: strict)
            write.session? session, strict: strict
          end
        end
      end
    end
  end
end
