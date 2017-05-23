module MessageStore
  module EventStore
    module Controls
      module Write
        def self.call(messages=nil, instances: nil, stream_name: nil)
          stream_name ||= StreamName.example

          if messages.nil?
            instances ||= 1

            messages = instances.times.map do |position|
              MessageData::Write.example
            end
          else
            messages = Array(messages)
          end

          ::EventStore::HTTP::Write.(messages, stream_name)

          stream_name
        end
      end
    end
  end
end
