module EventSource
  module EventStore
    module HTTP
      class Get
        include Log::Dependency

        configure :get

        initializer :batch_size, w(:precedence), a(:long_poll_duration)

        def precedence
          @precedence ||= Defaults.precedence
        end

        dependency :session, Session
        dependency :read_stream, ::EventStore::HTTP::ReadStream

        def self.build(batch_size: nil, precedence: nil, long_poll_duration: nil, session: nil)
          instance = new batch_size, precedence, long_poll_duration
          Session.configure instance, session: session
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
          logger.trace { "Reading stream (StreamName: #{stream_name}, Position: #{position || '(start)'}, Direction: #{direction}, BatchSize: #{batch_size})" }

          stream_name = StreamName.canonize stream_name

          if precedence == :desc
            position = desc_position stream_name, position

            if position < 0
              logger.debug { "Reading backward across start of stream (StreamName: #{stream_name}, Position: #{position || '(start)'}, Direction: #{direction}, BatchSize: #{batch_size}, Events: 0)" }
              return []
            end
          end

          begin
            events = read_stream.(
              stream_name,
              position: position,
              direction: direction,
              batch_size: batch_size
            )
          rescue ::EventStore::HTTP::ReadStream::StreamNotFoundError
            events = []
          end

          events.reverse! if precedence == :desc

          logger.debug { "Done reading stream (StreamName: #{stream_name}, Position: #{position || '(start)'}, Direction: #{direction}, BatchSize: #{batch_size}, Events: #{events.count})" }

          events
        end

        def desc_position(stream_name, position)
          begin
            head_event, * = read_stream.(
              stream_name,
              position: :head,
              direction: :backward,
              batch_size: 1
            )
          rescue ::EventStore::HTTP::ReadStream::StreamNotFoundError
            return -1
          end

          if position.nil?
            head_event.position
          else
            head_event.position - position
          end
        end

        def direction
          if precedence == :asc
            :forward
          else
            :backward
          end
        end

        module Defaults
          def self.precedence
            :asc
          end
        end
      end
    end
  end
end
