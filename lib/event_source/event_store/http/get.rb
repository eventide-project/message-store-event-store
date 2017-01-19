module EventSource
  module EventStore
    module HTTP
      class Get
        include Log::Dependency

        configure :get

        initializer :batch_size, :position

        dependency :session, Session
        dependency :read_stream, ::EventStore::HTTP::ReadStream

        def self.build(batch_size: nil, precedence: nil, session: nil)
          instance = new batch_size, precedence
          Session.configure instance, session: session
          ::EventStore::HTTP::ReadStream.configure instance
          instance.configure
          instance
        end

        def self.call(stream_name, position: nil, **build_arguments)
          instance = build **build_arguments
          instance.(stream_name, position: position)
        end

        def configure
          read_stream.embed_body
          read_stream.output_schema = Result
        end

        def call(stream_name, position: nil)
          logger.trace { "Reading stream (StreamName: #{stream_name}, Position: #{position || '(start)'})" }

          events = read_stream.(
            stream_name,
            position: position,
            batch_size: batch_size
          )

          logger.debug { "Done reading stream (StreamName: #{stream_name}, Position: #{position || '(start)'}, Events: #{events.count})" }

          events
        end
      end
    end
  end
end
