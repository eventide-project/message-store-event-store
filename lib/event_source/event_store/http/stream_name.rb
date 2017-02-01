module EventSource
  module EventStore
    module HTTP
      module StreamName
        def self.canonize(stream_name)
          if EventSource::StreamName.category? stream_name
            category_stream_name stream_name
          else
            stream_name
          end
        end

        def self.category_stream_name(category)
          "$ce-#{category}"
        end
      end
    end
  end
end
