module EventSource
  module EventStore
    module HTTP
      module Controls
        module Write
          def self.call(event_count=nil, data: nil, metadata: nil, stream_name: nil, category: nil, type: nil)
            event_count ||= 1

            if stream_name.nil?
              stream_name = StreamName.example category: category
            end

            ::EventStore::HTTP::Connect.() do |http|
              event_count.times do
                post = Session::Request::WriteEvent.example(
                  type: type,
                  data: data,
                  metadata: metadata,
                  stream_name: stream_name
                )

                response = http.request post

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

