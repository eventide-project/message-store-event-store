module EventSource
  module EventStore
    module HTTP
      class Connect
        module Telemetry
          class Sink
            include ::Telemetry::Sink

            record :connected
          end

          Connected = Struct.new :host, :port, :net_http
        end
      end
    end
  end
end
