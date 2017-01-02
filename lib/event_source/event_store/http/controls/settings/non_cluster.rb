module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module NonCluster
            def self.example
              Settings.example host: hostname
            end

            def self.hostname
              'eventstore.example'
            end

            def self.ip_address
              IPAddress.available
            end
          end
        end
      end
    end
  end
end
