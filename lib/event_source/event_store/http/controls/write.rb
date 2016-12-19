module EventSource
  module EventStore
    module HTTP
      module Controls
        module Write
          def self.call(ending_position=nil, data: nil, metadata: nil, stream_name: nil, type: nil)
            ending_position ||= 0
            stream_name ||= StreamName.example

            host = Settings.get :host
            port = Settings.get :port

            Net::HTTP.start host, port do |http|
              (0..ending_position).each do |position|
                event_data = EventData::Write.example(
                  type: type,
                  data: data,
                  metadata: metadata
                )

                event_id = Identifier::UUID::Random.get

                request_data = JSON.pretty_generate [
                  {
                    'eventId' => event_id,
                    'eventType' => event_data.type,
                    'data' => event_data.data,
                    'metadata' => event_data.metadata
                  }
                ]

                headers = { 'Content-Type' => MediaTypes.vnd_event_store_events_json }

                path = "/streams/#{stream_name}"

                response = http.request_post path, request_data, headers

                unless response.code.to_i == 201
                  fail "Write failed (StatusCode: #{response.code}, ReasonPhrase: #{response.message})"
                end
              end
            end

            stream_name
          end
        end
      end
    end
  end
end
