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
          logger.trace { "Connecting to EventStore (Host: #{host.inspect}, Port: #{port.inspect})" }

          net_http_session = Net::HTTP.new host, port
          net_http_session.start

          self.net_http = net_http_session

          logger.debug { "Connected to EventStore (Host: #{host.inspect}, Port: #{port.inspect})" }

          net_http
        end

        def connected?
          return false if net_http.nil?

          net_http.started?
        end

        def close
          logger.trace(tag: :http) { "Closing net_http" }

          conn = net_http

          self.net_http = nil

          conn.finish

          logger.debug(tag: :http) { "Connection closed" }

          conn
        end

        def post(path, request_body, media_type, &probe)
          logger.trace(tag: :http) { "Issuing POST request (Path: #{path})" }
          logger.trace(tags: [:http, :data]) {
            "Request (ContentLength: #{request_body.bytesize}, MediaType: #{media_type}):\n\n#{request_body}"
          }

          initheader = { 'Content-Type' => media_type }

          response = net_http.request_post path, request_body, initheader

          status_code = response.code.to_i

          logger.debug(tag: :http) { "POST request issued (Path: #{path}, StatusCode: #{status_code}, ReasonPhrase: #{response.message})" }

          if response.body.empty?
            logger.debug(tags: [:http, :data]) { "Response: (none)" }
          else
            logger.debug(tags: [:http, :data]) { "Response:\n\n#{response.body}" }
          end

          probe.(response) if probe

          status_code
        end
      end
    end
  end
end
