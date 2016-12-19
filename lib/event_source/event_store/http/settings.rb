module EventSource
  module EventStore
    module HTTP
      class Settings < ::Settings
        def self.data_source
          'settings/event_source_event_store_http.json'
        end

        def self.instance
          @instance ||= build
        end

        def self.names
          %i(host port read_timeout)
        end

        def self.set(receiver)
          instance.set receiver
        end

        def self.get(name)
          instance.get name
        end
      end
    end
  end
end
