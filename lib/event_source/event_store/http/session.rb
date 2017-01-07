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

          logger.trace(tag: :event_store_http) { "Issuing #{request.method} request (#{LogText.request_attributes request})" }
          logger.trace(tag: :data) { LogText.request_body request } if request.request_body_permitted?

          response = connection.request request

          if Net::HTTPRedirection === response && !redirect
            logger.debug(tag: :event_store_http) { "#{request.method} request received redirect response (#{LogText.request_attributes request}, #{LogText.response_attributes response}, Location: #{response['Location'] || '(none)'})" }

            telemetry.record :redirected, Telemetry::Redirected.new(request.path, connection.address, response['Location'])

            location = URI.parse response['Location']

            if request['ES-RequireMaster'] == 'true'
              leader_ip_address = location.host
              establish_connection leader_ip_address
            end

            redirect_request = request.class.new location.path
            request.each_header do |name, value|
              redirect_request[name] = value unless name == 'host'
            end
            redirect_request.body = request.body if request.body

            response = self.(redirect_request, redirect: true)

            return response
          end

          logger.debug(tag: :event_store_http) { "#{request.method} request issued (#{LogText.request_attributes request}, #{LogText.response_attributes response})" }
          logger.debug(tag: :data) { LogText.response_body response }

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
          logger.trace(tag: :event_store_connection) { "Establishing connection to EventStore (#{LogText.establishing_connection self, leader_ip_address})" }

          close if connected?

          unless leader_ip_address || disable_leader_detection
            leader_status_queried_telemetry = Telemetry::LeaderStatusQueried.new

            begin
              leader_status = get_leader_status.()
              leader_ip_address = leader_status.http_ip_address

              leader_status_queried_telemetry.leader_status = leader_status

            rescue ::EventStore::Cluster::LeaderStatus::GossipEndpoint::Get::NonClusterError => error
              leader_status_queried_telemetry.error = error
              logger.warn(tag: :event_store_connection) { "Could not determine cluster leader (#{LogText.establishing_connection self, leader_ip_address}, Error: #{error.class})" }
            end

            telemetry.record :leader_status_queried, leader_status_queried_telemetry
          end

          connection = connect.(leader_ip_address)

          telemetry.record :connection_established, Telemetry::ConnectionEstablished.new(leader_ip_address || host, port, connection)

          logger.info(tag: :event_store_connection) { "Connection to EventStore established (#{LogText.connection_established self, leader_ip_address})" }

          self.connection = connection

          connection
        end
      end
    end
  end
end
