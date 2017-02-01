module EventSource
  module EventStore
    module HTTP
      class Get
        include Log::Dependency

        configure :get

        initializer :batch_size, a(:long_poll_duration)

        dependency :read_stream, ::EventStore::HTTP::ReadStream
        dependency :session, Session

        def self.build(batch_size: nil, long_poll_duration: nil, session: nil)
          instance = new batch_size, long_poll_duration

          session = Session.configure instance, session: session
          ::EventStore::HTTP::ReadStream.configure instance, session: session

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

          unless long_poll_duration.nil?
            read_stream.enable_long_poll long_poll_duration
          end
        end

        def call(stream_name, position: nil)
          logger.trace { "Reading stream (StreamName: #{stream_name}, Position: #{position || '(start)'}, BatchSize: #{batch_size})" }

          begin
            events = read_stream.(
              stream_name,
              position: position,
              batch_size: batch_size
            )
          rescue ::EventStore::HTTP::ReadStream::StreamNotFoundError
            events = []
          end

          logger.debug { "Done reading stream (StreamName: #{stream_name}, Position: #{position || '(start)'}, BatchSize: #{batch_size}, Events: #{events.count})" }

          events
        end
      end
    end
  end
end
