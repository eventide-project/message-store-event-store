module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          def self.example(hostname: nil)
            hostname ||= NonCluster::Available::Hostname.example

            data = {
              :host => hostname,
              :port => Port.example
            }

            EventStore::HTTP::Settings.build data
          end
        end
      end
    end
  end
end
