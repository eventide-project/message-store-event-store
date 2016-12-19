module EventSource
  module EventStore
    module HTTP
      module Controls
        module MediaType
          def self.events
            'application/vnd.eventstore.events+json'
          end

          def self.unknown
            'application/octet-stream'
          end
        end
      end
    end
  end
end
