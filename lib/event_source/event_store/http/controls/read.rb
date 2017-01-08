module EventSource
  module EventStore
    module HTTP
      module Controls
        module Read
          module Event
            def self.call(stream_name, position: nil)
              position ||= 0

              ::EventStore::HTTP::Connect.() do |http|
                http.request_get(
                  "/streams/#{stream_name}/#{position}",
                  { 'Accept' => EventSource::EventStore::HTTP::MediaTypes.vnd_event_store_atom_json }
                )
              end
            end
          end

          module Stream
            def self.call(stream_name, position: nil, slice_size: nil)
              position ||= 0
              slice_size ||= 20

              ::EventStore::HTTP::Connect.() do |http|
                http.request_get(
                  "/streams/#{stream_name}/#{position}/forward/#{slice_size}?embed=body",
                  { 'Accept' => EventSource::EventStore::HTTP::MediaTypes.vnd_event_store_atom_json }
                )
              end
            end
          end
        end
      end
    end
  end
end
