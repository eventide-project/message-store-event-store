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

            messages = []

            entries.reverse_each do |atom_event|
              message = MessageData::Read.new
              message.id = atom_event.fetch :event_id
              message.type = atom_event.fetch :event_type

              data_text = atom_event.fetch :data
              message.data = ::EventStore::HTTP::JSON::Deserialize.(data_text)

              if atom_event.key? :meta_data
                metadata_text = atom_event.fetch :meta_data
                message.metadata = ::EventStore::HTTP::JSON::Deserialize.(metadata_text)
              end

              message.stream_name = atom_event.fetch :stream_id

              message.position = atom_event.fetch :event_number
              message.global_position = atom_event.fetch :position_event_number
              message.time = Clock.parse atom_event.fetch(:updated)

              messages << message
            end

            messages
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
