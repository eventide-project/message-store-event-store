module EventSource
  module EventStore
    module HTTP
      module Controls
        module URI
          module Path
            module Stream
              def self.example(**stream_arguments)
                stream = Controls::Stream.example **stream_arguments

                stream_id = StreamName.get_id stream.name

                "/streams/#{stream.category}-#{stream_id}"
              end
            end
          end
        end
      end
    end
  end
end
