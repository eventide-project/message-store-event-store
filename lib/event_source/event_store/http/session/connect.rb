module EventSource
  module EventStore
    module HTTP
      class Session
        class Connect
          include Log::Dependency

          setting :host
          setting :port
          setting :read_timeout

          def call
            net_http = Net::HTTP.new host, port
            net_http.read_timeout = read_timeout if read_timeout
            net_http.start
            net_http

          rescue SocketError
            error_message = "Could not connect to EventStore (Host: #{host}, Port: #{port})"
            logger.error error_message
            raise ConnectionError, error_message
          end

          ConnectionError = Class.new StandardError
        end
      end
    end
  end
end
