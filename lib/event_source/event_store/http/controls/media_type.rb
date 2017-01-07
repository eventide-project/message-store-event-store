module EventSource
  module EventStore
    module HTTP
      module Controls
        module MediaType
          def self.example
            unknown
          end

          def self.events
            EventStore::HTTP::MediaTypes.vnd_event_store_events_json
          end

          def self.stream
            EventStore::HTTP::MediaTypes.vnd_event_store_atom_json
          end

          def self.unknown
            'application/octet-stream'
          end
        end
      end
    end
  end
end
