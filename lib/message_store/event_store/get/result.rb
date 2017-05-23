module MessageStore
  module EventStore
    class Get
      module Result
        module Transformer
          def self.json
            JSON
          end

          def self.instance(raw_data)
            entries = raw_data.fetch :entries

            events = []

            entries.reverse_each do |atom_event|
              event = MessageData::Read.new
              event.id = atom_event.fetch :event_id
              event.type = atom_event.fetch :event_type

              data_text = atom_event.fetch :data
              event.data = ::EventStore::HTTP::JSON::Deserialize.(data_text)

              if atom_event.key? :meta_data
                metadata_text = atom_event.fetch :meta_data
                event.metadata = ::EventStore::HTTP::JSON::Deserialize.(metadata_text)
              end

              event.stream_name = atom_event.fetch :stream_id

              event.position = atom_event.fetch :event_number
              event.global_position = atom_event.fetch :position_event_number
              event.time = Clock.parse atom_event.fetch(:updated)

              events << event
            end

            events
          end

          module JSON
            def self.read(text)
              ::EventStore::HTTP::JSON::Deserialize.(text)
            end
          end
        end
      end
    end
  end
end
