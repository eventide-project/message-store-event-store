module EventSource
  module EventStore
    module HTTP
      module Controls
        module Cluster
          module IPAddress
            def self.example(i=nil)
              i ||= 1

              "127.0.111.#{i}"
            end
            
            module List
              def self.example
                range.map do |i|
                  IPAddress.example i
                end
              end

              def self.range
                (1..3)
              end
            end
          end
        end
      end
    end
  end
end
