module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module NonCluster
            def self.hostname
              'eventstore.example'
            end

            def self.ip_address
              Settings.ip_address
            end
          end
        end
      end
    end
  end
end
