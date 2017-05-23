module MessageStore
  module EventStore
    class Write
      include MessageStore::Write

      dependency :put, Put

      def configure(session: nil)
        Put.configure self, session: session
      end

      def write(batch, stream_name, expected_version: nil)
        logger.trace { "Writing batch (Stream Name: #{stream_name}, Number of Messages: #{batch.count}, Expected Version: #{expected_version.inspect})" }

        position = put.(batch, stream_name, expected_version: expected_version)

        last_position = position + (batch.count - 1)

        logger.debug { "Wrote batch (Stream Name: #{stream_name}, Number of Messages: #{batch.count}, Expected Version: #{expected_version.inspect}, Last Position: #{last_position})" }

        last_position
      end

      module Assertions
        def self.extended(write)
          write.put.extend Put::Assertions
        end

        def session?(session, strict: nil)
          put.session? session, strict: strict
        end
      end
    end
  end
end
