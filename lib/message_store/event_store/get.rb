module MessageStore
  module EventStore
    class Get
      include Log::Dependency

      configure :get

      initializer :batch_size, a(:long_poll_duration)

      def batch_size
        @batch_size ||= Defaults.batch_size
      end

      dependency :read_stream, ::EventStore::HTTP::ReadStream
      dependency :session, Session

      def self.build(batch_size: nil, long_poll_duration: nil, session: nil)
        instance = new(batch_size, long_poll_duration)

        Session.configure(instance, session: session)

        session ||= instance.session
        ::EventStore::HTTP::ReadStream.configure(instance, session: session)

        instance.configure
        instance
      end

      def self.call(stream_name, position: nil, **build_arguments)
        instance = build(**build_arguments)
        instance.(stream_name, position: position)
      end

      def configure
        read_stream.embed_body
        read_stream.output_schema = Result

        unless long_poll_duration.nil?
          read_stream.enable_long_poll(long_poll_duration)
        end
      end

      def call(stream_name, position: nil)
        logger.trace { "Reading stream (Stream Name: #{stream_name}, Position: #{position || '(start)'}, Batch Size: #{batch_size})" }

        begin
          messages = read_stream.(
            stream_name,
            position: position,
            batch_size: batch_size
          )
        rescue ::EventStore::HTTP::ReadStream::StreamNotFoundError
          messages = []
        end

        logger.debug { "Done reading stream (Stream Name: #{stream_name}, Position: #{position || '(start)'}, Batch Size: #{batch_size}, Messages: #{messages.count})" }

        messages
      end

      module Defaults
        def self.batch_size
          20
        end
      end
    end
  end
end
