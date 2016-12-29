module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module NonCluster
            def self.example
              hostname = Available::Hostname.example

              Settings.example hostname: hostname
            end

            module Available
              module Hostname
                def self.example
                  'eventstore.example'
                end
              end

              module IPAddress
                def self.example
                  '127.0.0.1'
                end
              end
            end

            module Unavailable
              module Hostname
                def self.example
                  'eventstore-unavailable.example'
                end
              end

              module IPAddress
                def self.example
                  '127.0.0.2'
                end
              end
            end
          end
        end
      end
    end
  end
end
