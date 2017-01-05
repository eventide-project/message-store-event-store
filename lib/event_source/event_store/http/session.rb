module EventSource
  module EventStore
    module HTTP
      class Session
        include Log::Dependency

        attr_writer :connection

        dependency :connect, ::EventStore::HTTP::Connect
        dependency :get_leader, ::EventStore::Clustering::GetLeader

        def self.build(settings=nil, namespace: nil)
          instance = new

          connect = ::EventStore::HTTP::Connect.configure(
            instance,
            settings,
            namespace: namespace
          )

          ::EventStore::Clustering::GetLeader.configure instance, connect

          instance
        end

        def connection
          @connection ||= establish_connection
        end

        def establish_connection
          leader_status = get_leader.()

          connect.(leader_status.http_ip_address)

        rescue ::EventStore::Clustering::GossipEndpoint::Get::NonClusterError
          connect.()
        end
      end
    end
  end
end
