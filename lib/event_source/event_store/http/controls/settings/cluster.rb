module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module Cluster
            def self.example
              host = ::EventStore::Cluster::LeaderStatus::Controls::Hostname.example

              HTTP::Settings.build({
                :host => host
              })
            end
          end
        end
      end
    end
  end
end
