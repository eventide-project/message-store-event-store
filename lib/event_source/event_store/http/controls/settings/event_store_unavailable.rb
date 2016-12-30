module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module EventStoreUnavailable
            def self.hostname
              'unavailable.eventstore.example'
            end

            def self.ip_address
              '127.0.0.2'
            end
          end
        end
      end
    end
  end
end
