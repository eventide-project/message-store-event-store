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

        def get(path, media_type, headers=nil, &probe)
          headers ||= {}

          logger.trace(tag: :http) {
            "Issuing GET request (Path: #{path}, MediaType: #{media_type})"
          }

          headers['Accept'] = media_type

          response = connection.request_get path, headers

          status_code = response.code.to_i
          response_body = response.body if (200..399).include? status_code

          logger.debug(tag: :http) {
            "GET request issued (Path: #{path}, MediaType: #{media_type}, StatusCode: #{status_code}, ReasonPhrase: #{response.message}, ContentLength: #{response_body&.bytesize.inspect})"
          }

          if response.body.empty?
            logger.debug(tags: [:data]) { "Response: (none)" }
          else
            logger.debug(tags: [:data]) { "Response:\n\n#{response.body}" }
          end

          probe.(response) if probe

          data = Telemetry::Get.new(
            path,
            status_code,
            response.message,
            response.body,
            media_type
          )

          telemetry.record :get, data

          return status_code, response_body
        end

        def post(path, request_body, media_type, headers=nil, &probe)
          headers ||= {}
          headers['Content-Type'] = media_type

          logger.trace(tag: :http) {
            "Issuing POST request (Path: #{path}, MediaType: #{media_type}, ContentLength: #{request_body.bytesize})"
          }
          logger.trace(tags: [:data]) { "Request:\n\n#{request_body}" }

          response = connection.request_post path, request_body, headers

          status_code = response.code.to_i

          logger.debug(tag: :http) {
            "POST request issued (Path: #{path}, MediaType: #{media_type}, ContentLength: #{request_body.bytesize}, StatusCode: #{status_code}, ReasonPhrase: #{response.message})"
          }

          if response.body.empty?
            logger.debug(tags: [:data]) { "Response: (none)" }
          else
            logger.debug(tags: [:data]) { "Response:\n\n#{response.body}" }
          end

          probe.(response) if probe

          data = Telemetry::Post.new(
            path,
            status_code,
            response.message,
            request_body,
            media_type
          )

          telemetry.record :post, data

          status_code
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

          data = Telemetry::ConnectionEstablished.new host, port, connection

          telemetry.record :connection_established, data

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
