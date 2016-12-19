module EventSource
  module EventStore
    module HTTP
      class Session
        include Log::Dependency

        dependency :net_http, NetHTTP
        dependency :telemetry, ::Telemetry

        def self.build
          instance = new

          Settings.set instance
          ::Telemetry.configure instance
          NetHTTP.configure instance

          instance.connect

          instance
        end

        def self.register_telemetry_sink(instance)
          sink = Telemetry::Sink.new

          instance.telemetry.register sink

          sink
        end

        def connect
          host = net_http.address
          port = net_http.port

          logger.trace(tag: [:http, :db_connection]) {
            "Connecting to EventStore (Host: #{host.inspect}, Port: #{port.inspect})"
          }

          net_http.start

          data = Telemetry::Connected.new host, port

          telemetry.record :connected, data

          logger.debug(tag: [:http, :db_connection]) {
            "Connected to EventStore (Host: #{host.inspect}, Port: #{port.inspect})"
          }

          net_http
        end

        def connected?
          net_http.started?
        end

        def close
          logger.trace(tag: [:http, :db_connection]) { "Closing connection to EventStore" }

          net_http.finish

          logger.debug(tag: [:http, :db_connection]) { "Connection to EventStore closed" }

          net_http
        end

        def get(path, media_type, &probe)
          logger.trace(tag: :http) {
            "Issuing GET request (Path: #{path}, MediaType: #{media_type})"
          }

          initheader = { 'Accept' => media_type }

          response = net_http.request_get path, initheader

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

        def post(path, request_body, media_type, &probe)
          logger.trace(tag: :http) {
            "Issuing POST request (Path: #{path}, MediaType: #{media_type}, ContentLength: #{request_body.bytesize})"
          }
          logger.trace(tags: [:data]) { "Request:\n\n#{request_body}" }

          initheader = { 'Content-Type' => media_type }

          response = net_http.request_post path, request_body, initheader

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
      end
    end
  end
end
