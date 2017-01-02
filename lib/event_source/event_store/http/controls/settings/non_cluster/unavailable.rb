module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module NonCluster
            module Unavailable
              def self.example
                Settings.example host: hostname
              end

              def self.hostname
                'unavailable.eventstore.example'
              end

              def self.ip_address
                IPAddress.unavailable
              end
            end
          end
        end
      end
    end
  end
end
