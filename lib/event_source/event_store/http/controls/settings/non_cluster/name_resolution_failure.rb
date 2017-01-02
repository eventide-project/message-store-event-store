module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module NonCluster
            module NameResolutionFailure
              def self.example
                Settings.example host: hostname
              end

              def self.hostname
                'unknown.eventstore.example'
              end
            end
          end
        end
      end
    end
  end
end
