module EventSource
  module EventStore
    module HTTP
      module StreamName
        def self.canonize(stream_name)
          stream = EventSource::Stream.new stream_name

          if stream.category?
            category_stream_name stream_name
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
