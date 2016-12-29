module EventSource
  module EventStore
    module HTTP
      module Controls
        module Session
          module ResolvDNS
            def self.example
              Resolv::DNS.new :nameserver_port => [['127.0.0.1', 10053]]
            end

            def self.configure(receiver)
              resolv_dns = example

              receiver.resolv_dns = resolv_dns

              resolv_dns
            end

            module IPAddress
              def self.example
                '127.0.0.1'
              end
            end

            module Port
              def self.example
                10053
              end
            end
          end
        end
      end
    end
  end
end
