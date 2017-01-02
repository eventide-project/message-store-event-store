module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module Cluster
            module Unavailable
              def self.example
                Settings.example host: hostname
              end

              def self.hostname
                'unavailable.cluster.eventstore.example'
              end

              module IPAddress
                def self.example(member=nil)
                  member ||= 1

                  Settings::IPAddress.unavailable cluster_member: member
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
