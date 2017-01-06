module EventSource
  module EventStore
    module HTTP
      module Controls
        module Session
          module Request
            module WriteEvent
              def self.example(data: nil, metadata: nil, type: nil, stream_name: nil, headers: nil)
                stream_name ||= StreamName.example
                headers ||= {}

                event_data = EventData::Write.example(
                  type: type,
                  data: data,
                  metadata: metadata
                )

                request_body = JSON.pretty_generate [
                  {
                    'eventId' => Identifier::UUID::Random.get,
                    'eventType' => event_data.type,
                    'data' => event_data.data,
                    'metadata' => event_data.metadata
                  }
                ]

                headers['Content-Type'] ||= MediaTypes.vnd_event_store_events_json

                path = "/streams/#{stream_name}"

                post = Net::HTTP::Post.new path, headers
                post.body = request_body
                post
              end
            end
          end
        end
      end
    end
  end
end
