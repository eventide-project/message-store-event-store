module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module IPAddress
            def self.available(cluster_member: nil)
              if cluster_member.nil?
                '127.0.0.1'
              else
                "127.0.111.#{cluster_member}"
              end
            end

            def self.unavailable(cluster_member: nil)
              if cluster_member.nil?
                '127.0.0.2'
              else
                "127.0.222.#{cluster_member}"
              end
            end

            def self.non_routable
              '10.0.0.0'
            end
          end
        end
      end
    end
  end
end
