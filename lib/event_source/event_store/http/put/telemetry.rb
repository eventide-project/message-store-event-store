module EventSource
  module EventStore
    module HTTP
      class Put
        module Telemetry
          class Sink
            include ::Telemetry::Sink

            record :post
          end

          Post = Struct.new :request, :response
        end
      end
    end
  end
end
