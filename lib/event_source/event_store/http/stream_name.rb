module EventSource
  module EventStore
    module HTTP
      module StreamName
        def self.category_stream_name(category)
          "$ce-#{category}"
        end
      end
    end
  end
end
