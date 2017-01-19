module EventSource
  module EventStore
    module HTTP
      module Controls
        module Write
          def self.call(events=nil, instances: nil, stream_name: nil)
            stream_name ||= StreamName.example

            if events.nil?
              instances ||= 1

              events = instances.times.map do |position|
                EventData::Write.example
              end
            else
              events = Array(events)
            end

            ::EventStore::HTTP::Write.(events, stream_name)

            stream_name
          end
        end
      end
    end
  end
end
