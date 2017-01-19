module EventSource
  module EventStore
    module HTTP
      module Controls
        module Write
          def self.call(events=nil, stream_name: nil)
            stream_name ||= StreamName.example

            events = Array(events)
            events << EventData::Write.example if events.empty?

            events.each do |event|
              event.id ||= Identifier::UUID::Random.get
            end

            batch = ::EventStore::HTTP::MediaTypes::Events::Data.new
            batch.events = events

            ::EventStore::HTTP::Write.(batch, stream_name)

            stream_name
          end
        end
      end
    end
  end
end
