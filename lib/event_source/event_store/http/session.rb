module EventSource
  module EventStore
    module HTTP
      class Session
        include Log::Dependency

        extend Build
        extend Configure
        extend Telemetry::RegisterSink

        attr_writer :connection
        attr_writer :disable_leader_detection

        def disable_leader_detection
          if @disable_leader_detection.nil?
            @disable_leader_detection = Defaults.disable_leader_detection
          end

          @disable_leader_detection
        end

        dependency :connect, ::EventStore::HTTP::Connect
        dependency :get_leader_status, ::EventStore::Cluster::LeaderStatus::Get
        dependency :telemetry, ::Telemetry

        attr_accessor :host
        attr_accessor :port

        def call(request, redirect: nil, &probe)
          redirect ||= false

          logger.trace(tags: :http) { "Issuing #{request.method} request (#{LogText.request_attributes request})" }
          logger.trace(tag: :data) { LogText.request_body request } if request.request_body_permitted?

          response = connection.request request

          if Net::HTTPRedirection === response && !redirect
            logger.debug(tags: :http) { "#{request.method} request received redirect response (#{LogText.request_attributes request}, #{LogText.response_attributes response}, Location: #{response['Location'] || '(none)'})" }

            location = URI.parse response['Location']
            leader_ip_address = location.host

            telemetry.record :redirected, Telemetry::Redirected.new(request.path, connection.address, location)

            establish_connection leader_ip_address

            request['Host'] = nil
            response = self.(request, redirect: true)

            return response
          end

          logger.trace(tags: :http) { "#{request.method} request issued (#{LogText.request_attributes request}, #{LogText.response_attributes response})" }
          logger.trace(tag: :data) { LogText.response_body response }

          telemetry.record :http_request, Telemetry::HTTPRequest.build(request, response)

          probe.(response) if probe

          response
        end

        def connection
          @connection ||= establish_connection
        end

        def connected?
          !@connection.nil?
        end

        def close
          connection.finish

          self.connection = nil
        end

        def establish_connection(leader_ip_address=nil)
          logger.trace { "Establishing connection to EventStore (#{LogText.establishing_connection self, leader_ip_address})" }

          close if connected?

          unless leader_ip_address || disable_leader_detection
            leader_status_queried_telemetry = Telemetry::LeaderStatusQueried.new

            begin
              leader_status = get_leader_status.()
              leader_ip_address = leader_status.http_ip_address

              leader_status_queried_telemetry.leader_status = leader_status

            rescue ::EventStore::Cluster::LeaderStatus::GossipEndpoint::Get::NonClusterError => error
              leader_status_queried_telemetry.error = error
              logger.warn { "Could not determine cluster leader (#{LogText.establishing_connection self, leader_ip_address}, Error: #{error.class})" }
            end

            telemetry.record :leader_status_queried, leader_status_queried_telemetry
          end

          connection = connect.(leader_ip_address)

          telemetry.record :connection_established, Telemetry::ConnectionEstablished.new(leader_ip_address || host, port, connection)

          logger.debug { "Connection to EventStore established (#{LogText.connection_established self, leader_ip_address})" }

          self.connection = connection

          connection
        end
      end
    end
  end
end
