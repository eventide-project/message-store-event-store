module EventSource
  module EventStore
    module HTTP
      class Settings < ::Settings
        def self.data_source
          'settings/event_source_event_store_http.json'
        end

        def self.names
          %i(host port)
        end

        def self.set(receiver)
          instance = build
          instance.set receiver
        end
      end
    end
  end
end
