module EventSource
  module EventStore
    module HTTP
      class Connect
        module Telemetry
          class Sink
            include ::Telemetry::Sink

            record :connected
            record :leader_queried
          end

          LeaderQueried = Struct.new :leader_host, :net_http
          Connected = Struct.new :host, :port, :net_http
        end
      end
    end
  end
end
