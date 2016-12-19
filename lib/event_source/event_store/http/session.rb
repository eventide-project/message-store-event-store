module EventSource
  module EventStore
    module HTTP
      class Session
        include Log::Dependency

        attr_accessor :net_http

        setting :host
        setting :port

        def self.build
          instance = new
          Settings.set instance
          instance.connect
          instance
        end

        def connect
          logger.trace(tag: [:http, :db_connection]) {
            "Connecting to EventStore (Host: #{host.inspect}, Port: #{port.inspect})"
          }

          net_http_session = Net::HTTP.new host, port
          net_http_session.start

          self.net_http = net_http_session

          logger.debug(tag: [:http, :db_connection]) {
            "Connected to EventStore (Host: #{host.inspect}, Port: #{port.inspect})"
          }

          net_http
        end

        def connected?
          return false if net_http.nil?

          net_http.started?
        end

        def close
          logger.trace(tag: [:http, :db_connection]) { "Closing net_http" }

          conn = net_http

          self.net_http = nil

          conn.finish

          logger.debug(tag: [:http, :db_connection]) { "Connection closed" }

          conn
        end

        def get(path, media_type, &probe)
          logger.trace(tag: :http) { "Issuing GET request (Path: #{path}, MediaType: #{media_type})" }

          initheader = { 'Accept' => media_type }

          response = net_http.request_get path, initheader

          status_code = response.code.to_i

          logger.debug(tag: :http) { "GET request issued (Path: #{path}, MediaType: #{media_type}, StatusCode: #{status_code}, ReasonPhrase: #{response.message}, ContentLength: #{response.body&.bytesize.inspect})" }

          if response.body.empty?
            logger.debug(tags: [:data]) { "Response: (none)" }
          else
            logger.debug(tags: [:data]) { "Response:\n\n#{response.body}" }
          end

          probe.(response) if probe

          if (200..399).include? status_code
            return status_code, response.body
          else
            return status_code, nil
          end
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

          status_code
        end
      end
    end
  end
end
