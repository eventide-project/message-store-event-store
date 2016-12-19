module EventSource
  module EventStore
    module MediaTypes
      def self.vnd_event_store_atom_json
        'application/vnd.eventstore.atom+json'
      end

      def self.vnd_event_store_events_json
        'application/vnd.eventstore.events+json'
      end
    end
  end
end
