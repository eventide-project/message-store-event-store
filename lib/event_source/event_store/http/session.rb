module EventSource
  module EventStore
    module HTTP
      class Session
        include Log::Dependency

        attr_writer :connection

        dependency :connect, Connect
        dependency :get_leader, Clustering::GetLeader

        def self.build
          instance = new

          connect = Connect.configure instance

          Clustering::GetLeader.configure instance, connect

          instance.reconnect

          instance
        end

        def active?
          connection.active?
        end

        def close
          connection.finish
        end

        def connection
          @connection || reconnect
        end

        def reconnect(ip_address=nil)
          ip_address ||= get_leader.()

          self.connection = connect.(ip_address)
        end
      end
    end
  end
end
