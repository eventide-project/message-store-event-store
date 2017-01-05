module EventSource
  module EventStore
    module HTTP
      class Log < ::Log
        def tag!(tags)
          tags << :event_source_event_store_http
          tags << :verbose
        end
      end
    end
  end
end
