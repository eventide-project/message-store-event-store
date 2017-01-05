module EventSource
  module EventStore
    module HTTP
      class Session
        include Log::Dependency

        attr_writer :connection

        dependency :connect, ::EventStore::HTTP::Connect
        dependency :get_leader, ::EventStore::Clustering::GetLeader
        dependency :telemetry, ::Telemetry

        setting :disable_leader_detection

        def self.build(settings=nil, namespace: nil, disable_leader_detection: nil)
          disable_leader_detection ||= Defaults.disable_leader_detection

          instance = new

          connect = ::EventStore::HTTP::Connect.configure(
            instance,
            settings,
            namespace: namespace
          )

          ::EventStore::Clustering::GetLeader.configure instance, connect

          ::Telemetry.configure instance

          instance.disable_leader_detection = disable_leader_detection

          instance
        end

        def self.register_telemetry_sink(instance)
          sink = Telemetry::Sink.new

          instance.telemetry.register sink

          sink
        end

        def connection
          @connection ||= establish_connection
        end

        def establish_connection
          unless disable_leader_detection
            telemetry_record = Telemetry::LeaderStatusQueried.new

            begin
              leader_status = get_leader.()

              telemetry_record.leader_status = leader_status

            rescue ::EventStore::Clustering::GossipEndpoint::Get::NonClusterError => error
              telemetry_record.error = error
            end

            telemetry.record :leader_status_queried, telemetry_record
          end

          if leader_status
            connect.(leader_status.http_ip_address)
          else
            connect.()
          end
        end
      end
    end
  end
end
