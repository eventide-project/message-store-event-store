module EventSource
  module EventStore
    module HTTP
      module Controls
        module NetHTTP
          def self.example(ip_address: nil)
            ip_address ||= Settings.ip_address
            port = Settings.port

            net_http = Net::HTTP.new ip_address, port
            net_http.start
            net_http
          end

          module NonCluster
            def self.example
              NetHTTP.example
            end
          end

          module Cluster
            def self.example
              ip_address = Settings::Cluster.ip_address

              NetHTTP.example ip_address: ip_address
            end
          end
        end
      end
    end
  end
end
