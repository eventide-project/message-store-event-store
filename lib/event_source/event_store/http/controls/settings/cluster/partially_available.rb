module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module Cluster
            module PartiallyAvailable
              def self.example
                ip_address_list = IPAddress.list

                Cluster.example(
                  hostname: hostname,
                  ip_address_list: ip_address_list
                )
              end

              def self.hostname
                'partially-available.cluster.eventstore.example'
              end

              module IPAddress
                def self.example(i=nil)
                  i ||= 1

                  if i == 1
                    Cluster::Unavailable::IPAddress.example i
                  else
                    Cluster::IPAddress.example i
                  end
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
