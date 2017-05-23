module MessageStore
  module EventStore
    class Get
      class Last
        include Log::Dependency

        configure :get_last

        dependency :read_stream, ::EventStore::HTTP::ReadStream
        dependency :session, Session

        def self.build(session: nil)
          instance = new
          instance.configure(session: session)
          instance
        end

        def self.call(stream_name, **build_arguments)
          instance = build(**build_arguments)
          instance.(stream_name)
        end

        def configure(session: nil)
          session = Session.configure(self, session: session)

          read_stream = ::EventStore::HTTP::ReadStream.configure(
            self,
            session: session
          )

          read_stream.embed_body
          read_stream.output_schema = Result
        end

        def call(stream_name)
          logger.trace { "Getting last message of stream (Stream Name: #{stream_name})" }

          begin
            message_data, * = read_stream.(
              stream_name,
              position: :head,
              direction: :backward,
              batch_size: 1
            )
          rescue ::EventStore::HTTP::ReadStream::StreamNotFoundError
          end

          logger.debug { "Got last message of stream (Stream Name: #{stream_name}, Message Type: #{message_data&.type.inspect}, Position: #{message_data&.position.inspect}, Global Position: #{message_data&.global_position.inspect})" }

          message_data
        end

        Assertions = Get::Assertions
      end
    end
  end
end
