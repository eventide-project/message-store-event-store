module EventSource
  module EventStore
    module HTTP
      module Controls
        module IPAddress
          def self.example
            '127.0.0.1'
          end

          Cluster = ::EventStore::Clustering::Controls::IPAddress

          module Cluster
            module Leader
              def self.get
                leader_ip_address, * = ::EventStore::Clustering::Controls::CurrentMembers.get

                leader_ip_address
              end
            end
          end
        end
      end
    end
  end
end
