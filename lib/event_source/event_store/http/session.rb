module EventSource
  module EventStore
    module HTTP
      class Session
        include Log::Dependency

        attr_writer :connection
        attr_writer :disable_leader_detection

        dependency :connect, ::EventStore::HTTP::Connect
        dependency :get_leader_status, ::EventStore::Clustering::GetLeaderStatus
        dependency :telemetry, ::Telemetry

        setting :host
        setting :port

        def self.build(settings=nil, namespace: nil)
          instance = new

          connect = ::EventStore::HTTP::Connect.configure(
            instance,
            settings,
            namespace: namespace
          )

          instance.host = connect.host
          instance.port = connect.port

          ::EventStore::Clustering::GetLeaderStatus.configure instance, connect

          ::Telemetry.configure instance

          instance
        end

        def self.configure(receiver, settings=nil, namespace: nil, session: nil, attr_name: nil)
          attr_name ||= :session

          if session.nil?
            instance = build settings, namespace: namespace
          else
            instance = session
          end

          receiver.public_send "#{attr_name}=", instance
          instance
        end

        def self.register_telemetry_sink(instance)
          sink = Telemetry::Sink.new

          instance.telemetry.register sink

          sink
        end

        def close
          connection.finish

          self.connection = nil
        end

        def connected?
          !@connection.nil?
        end

        def connection
          @connection ||= establish_connection
        end

        def establish_connection
          logger.trace { "Establishing connection to EventStore (Host: #{host}, Port: #{port})" }

          unless disable_leader_detection
            telemetry_record = Telemetry::LeaderStatusQueried.new

            begin
              leader_status = get_leader_status.()

              telemetry_record.leader_status = leader_status

            rescue ::EventStore::Clustering::GossipEndpoint::Get::NonClusterError => error
              telemetry_record.error = error
              logger.warn { "Could not determine cluster leader (Host: #{host}, Port: #{port}, Error: #{error.class})" }
            end

            telemetry.record :leader_status_queried, telemetry_record
          end

          if leader_status
            connection = connect.(leader_status.http_ip_address)
          else
            connection = connect.()
          end

          logger.trace { "Connection to EventStore established (Host: #{host}, Port: #{port}, LeaderIPAddress: #{leader_status&.http_ip_address || '(not detected)'})" }

          self.connection = connection
        end

        def disable_leader_detection
          if @disable_leader_detection.nil?
            @disable_leader_detection = Defaults.disable_leader_detection
          end

          @disable_leader_detection
        end
      end
    end
  end
end
