module EventSource
  module EventStore
    module HTTP
      module StreamName
        def self.canonize(stream_or_stream_name)
          stream =
            case stream_or_stream_name
            when EventSource::Stream then stream_or_stream_name
            else EventSource::Stream.new String(stream_or_stream_name)
            end

          if stream.category?
            category_stream_name stream.name
          else
            stream.name
          end
        end

        def self.category_stream_name(category)
          "$ce-#{category}"
        end
      end
    end
  end
end
