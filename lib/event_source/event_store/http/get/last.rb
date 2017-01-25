module EventSource
  module EventStore
    module HTTP
      class Get
        class Last
          include Log::Dependency

          configure :get_last

          dependency :read_stream, ::EventStore::HTTP::ReadStream
          dependency :session, Session

          def self.build(session: nil)
            instance = new
            instance.configure session: session
            instance
          end

          def self.call(stream_name, **build_arguments)
            instance = build **build_arguments
            instance.(stream_name)
          end

          def configure(session: nil)
            session = Session.configure self, session: session

            read_stream = ::EventStore::HTTP::ReadStream.configure(
              self,
              session: session
            )

            read_stream.embed_body
            read_stream.output_schema = Result
          end

          def call(stream_name)
            stream_name = StreamName.canonize stream_name

            logger.trace { "Getting last event of stream (StreamName: #{stream_name})" }

            begin
              last_event, * = read_stream.(
                stream_name,
                position: :head,
                direction: :backward,
                batch_size: 1
              )
            rescue ::EventStore::HTTP::ReadStream::StreamNotFoundError
            end

            logger.debug { "Got last event of stream (StreamName: #{stream_name}, EventType: #{event&.type.inspect}, Position: #{event&.position.inspect}, GlobalPosition: #{event&.global_position.inspect})" }

            last_event
          end
        end
      end
    end
  end
end
