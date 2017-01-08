module EventSource
  module EventStore
    module HTTP
      class Put
        module Telemetry
          class Sink
            include ::Telemetry::Sink

            record :post
            record :retry
          end

          Post = Struct.new :request, :response
          Retry = Struct.new :request, :error, :retry, :limit
        end
      end
    end
  end
end
