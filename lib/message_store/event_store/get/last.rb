module MessageStore
  module EventStore
    class Get
      class Last
        include MessageStore::Get::Last

        dependency :read_stream, ::EventStore::HTTP::ReadStream
        dependency :session, Session

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
          begin
            message_data, * = read_stream.(
              stream_name,
              position: :head,
              direction: :backward,
              batch_size: 1
            )
          rescue ::EventStore::HTTP::ReadStream::StreamNotFoundError
          end

          message_data
        end

        Assertions = Get::Assertions
      end
    end
  end
end
