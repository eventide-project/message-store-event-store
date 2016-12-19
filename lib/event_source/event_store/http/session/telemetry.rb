module EventSource
  module EventStore
    module HTTP
      class Session
        module Telemetry
          class Sink
            include ::Telemetry::Sink

            record :connected
            record :get
            record :post
          end

          Connected = Struct.new :host, :port

          Get = Struct.new(
            :path,
            :status_code,
            :reason_phrase,
            :response_body,
            :acceptable_media_type
          )

          Post = Struct.new(
            :path,
            :status_code,
            :reason_phrase,
            :request_body,
            :content_type
          )
        end
      end
    end
  end
end
