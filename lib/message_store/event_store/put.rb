module MessageStore
  module EventStore
    class Put
      include Log::Dependency

      configure :put

      dependency :write, ::EventStore::HTTP::Write

      def self.build(session: nil)
        session ||= Session.build

        instance = new
        ::EventStore::HTTP::Write.configure(instance, session: session)
        instance
      end

      def self.call(message_data, stream_name, expected_version: nil, session: nil)
        instance = build(session: session)
        instance.(message_data, stream_name, expected_version: expected_version)
      end

      def call(messages, stream_name, expected_version: nil)
        messages = Array(messages)

        expected_version = ExpectedVersion.canonize(expected_version)

        logger.trace { "Putting message data (Stream Name: #{stream_name}, Batch Size: #{messages.count}, Types: #{messages.map(&:type).inspect}, Expected Version: #{expected_version.inspect})" }

        messages.each do |message_data|
          message_data.metadata = nil if message_data.metadata&.empty?
        end

        begin
          location = write.(
            messages,
            stream_name,
            expected_version: expected_version
          )
        rescue ::EventStore::HTTP::Write::ExpectedVersionError => error
          raise ExpectedVersion::Error, error.message
        end

        *, position = location.path.split '/'

        logger.debug { "Put message data done (Stream Name: #{stream_name}, Batch Size: #{messages.count}, Types: #{messages.map(&:type).inspect}, Position: #{position}, Expected Version: #{expected_version.inspect})" }

        position.to_i
      end

      module Assertions
        def self.extended(put)
          put.write.extend(::EventStore::HTTP::Request::Assertions)
        end

        def session?(session, strict: nil)
          write.session?(session, strict: strict)
        end
      end
    end
  end
end
