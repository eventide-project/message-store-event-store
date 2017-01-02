module EventSource
  module EventStore
    module HTTP
      module Controls
        module Cluster
          module DNSServer
            def self.start(&block)
              hostname = Settings::Cluster.hostname
              ip_addresses = Settings::Cluster::IPAddress.list

              DNS::ResolveHost::Controls::Server.start(
                hostname: hostname,
                ip_addresses: ip_addresses,
                &block
              )
            end

            def self.port
              DNS::ResolveHost::Controls::Server::Port.example
            end
          end
        end
      end
    end
  end
end
