module MessageStore
  module EventStore
    module Controls
      module MessageData
        module Write
          module Text
            def self.example(event_id=nil, type: nil, data: nil, metadata: nil)
              event_id ||= EventID.example

              message_data = Write.example type: type, data: data, metadata: metadata

              event_type = message_data.type
              data = message_data.data
              metadata = message_data.metadata

              raw_data = {
                'eventId' => event_id,
                'eventType' => event_type,
                'data' => data
              }

              raw_data['metadata'] = metadata if metadata

              JSON.pretty_generate [raw_data]
            end
          end
        end
      end
    end
  end
end

