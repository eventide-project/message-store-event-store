module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module Cluster
            def self.example(hostname: nil)
              hostname ||= self.hostname

              port = Settings.port

              data = {
                :host => hostname,
                :port => port
              }
            end

            def self.hostname
              'cluster.eventstore.example'
            end

            module IPAddress
              def self.example(i=nil)
                i ||= 1

                "127.0.111.#{i}"
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
