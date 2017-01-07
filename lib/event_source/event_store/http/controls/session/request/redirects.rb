module EventSource
  module EventStore
    module HTTP
      module Controls
        module Session
          module Request
            module Redirects
              def self.example
                stream_name = StreamName.example
                headers ||= {}

                event_data = EventData::Write.example

                formatted_data = Casing::Camel.(event_data.to_h, symbol_to_string: true)

                headers['Content-Type'] = 'application/json'
                headers['ES-EventType'] = event_data.type
                headers['ES-EventId'] = nil

                request_body = JSON.pretty_generate formatted_data

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
