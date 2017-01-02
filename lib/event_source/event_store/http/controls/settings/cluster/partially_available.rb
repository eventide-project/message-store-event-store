module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module Cluster
            module PartiallyAvailable
              def self.example
                Settings.example host: hostname
              end

              def self.hostname
                'partially-available.cluster.eventstore.example'
              end

              module IPAddress
                def self.example(member=nil)
                  member ||= 1

                  if member == 1
                    Settings::IPAddress.unavailable cluster_member: member
                  else
                    Settings::IPAddress.available cluster_member: member
                  end
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
