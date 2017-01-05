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

        def call(request, &probe)
          response = request(request)

          telemetry_data = Telemetry::HTTPRequest.new(
            request.method,
            request.path,
            response.code.to_i,
            response.message,
            response.body,
            request['Accept']
          )

          if request.request_body_permitted?
            telemetry_data.request_body = request.body
            telemetry_data.content_type = request['Content-Type']
          end

          telemetry.record :http_request, telemetry_data

          probe.(response) if probe

          response
        end

        def request(request, redirect: nil)
          redirect ||= false

          log_attributes = "Path: #{request.path}, Host: #{connection.address}, MediaType: #{request['Content-Type'] || '(none)'}, ContentLength: #{request.body&.bytesize.to_i}, Accept: #{request['Accept'] || '(none)'}, Redirect: #{redirect}"

          logger.trace(tags: :http) { "Issuing #{request.method} request (#{log_attributes})" }

          if request.request_body_permitted?
            if request.body.nil? || request.body.empty?
              logger.trace(tag: :data) { "Request: (none)'" }
            else
              logger.trace(tag: :data) { "Request:\n\n#{request.body}" }
            end
          end

          response = connection.request request

          if Net::HTTPRedirection === response && !redirect
            logger.debug(tags: :http) { "#{request.method} request received redirect response (#{log_attributes}, StatusCode: #{response.code}, ReasonPhrase: #{response.message}, RedirectLocation: #{response['Location'] || '(none)'})" }

            location = URI.parse response['Location']

            self.connection = connect.(location.host)

            return request(request, redirect: true)
          end

          logger.trace(tags: :http) { "#{request.method} request issued (#{log_attributes}, StatusCode: #{response.code}, ReasonPhrase: #{response.message})" }

          if request.response_body_permitted?
            if response.body.empty?
              logger.debug(tag: :data) { "Response: (none)" }
            else
              logger.debug(tag: :data) { "Response:\n\n#{response.body}" }
            end
          end

          response
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
