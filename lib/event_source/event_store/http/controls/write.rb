module EventSource
  module EventStore
    module HTTP
      module Controls
        module Write
          def self.call(event_count=nil, data: nil, metadata: nil, stream_name: nil, type: nil)
            event_count ||= 1
            stream_name ||= StreamName.example

            host = Settings.get :host
            port = Settings.get :port

            event_data = EventData::Write.example(
              type: type,
              data: data,
              metadata: metadata
            )

            Net::HTTP.start host, port do |http|
              event_datum = (0...event_count).map do
                event_id = Identifier::UUID::Random.get

                {
                  'eventId' => event_id,
                  'eventType' => event_data.type,
                  'data' => event_data.data,
                  'metadata' => event_data.metadata
                }
              end

              headers = { 'Content-Type' => MediaTypes.vnd_event_store_events_json }

              path = "/streams/#{stream_name}"

              request_body = JSON.pretty_generate event_datum

              response = http.request_post path, request_body, headers

              unless response.code.to_i == 201
                fail "Write failed (StatusCode: #{response.code}, ReasonPhrase: #{response.message})"
              end
            end

            stream_name
          end
        end
      end
    end
  end
end
