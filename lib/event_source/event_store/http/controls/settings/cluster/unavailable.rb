module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module Cluster
            module Unavailable
              def self.example
                ip_addresses = IPAddress.list

                Cluster.example(
                  hostname: hostname,
                  ip_addresses: ip_addresses
                )
              end

              def self.hostname
                'unavailable.cluster.eventstore.example'
              end

              module IPAddress
                def self.example(i=nil)
                  i ||= 1

                  "127.0.222.#{i}"
                end

                def self.list
                  (1..3).map do |i|
                    example i
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
