module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module Cluster
            def self.example
              Settings.example host: hostname
            end

            def self.hostname
              'cluster.eventstore.example'
            end

            module IPAddress
              def self.example(member=nil)
                member ||= 1

                Settings::IPAddress.available cluster_member: member
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
