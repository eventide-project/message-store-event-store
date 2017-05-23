module MessageStore
  module EventStore
    module Controls
      module EventData
        module Write
          module Text
            def self.example(event_id=nil, type: nil, data: nil, metadata: nil)
              event_id ||= EventID.example

              event_data = Write.example type: type, data: data, metadata: metadata

              event_type = event_data.type
              data = event_data.data
              metadata = event_data.metadata

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

