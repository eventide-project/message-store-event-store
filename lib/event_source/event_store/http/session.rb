module EventSource
  module EventStore
    module HTTP
      class Session
        include Log::Dependency

        attr_accessor :connection

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

          self.connection = net_http_session

          logger.debug { "Connected to EventStore (Host: #{host.inspect}, Port: #{port.inspect})" }

          connection
        end

        def connected?
          return false if connection.nil?

          connection.started?
        end
      end
    end
  end
end
