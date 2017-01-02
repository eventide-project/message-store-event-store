module EventSource
  module EventStore
    module HTTP
      class Connect
        include Log::Dependency

        configure :connect

        setting :host
        setting :port
        setting :read_timeout
        setting :open_timeout

        def self.build(settings=nil, namespace: nil)
          settings ||= Settings.instance
          namespace = Array(namespace)

          instance = new
          settings.set instance, *namespace, strict: true
          instance
        end

        def self.call(**arguments, &block)
          instance = build **arguments
          instance.(&block)
        end

        def call(host=nil, &block)
          host ||= self.host

          logger.trace(tag: :db_connection) { "Establishing HTTP connection to EventStore (#{log_attributes})" }

          connection = Net::HTTP.new host, port
          connection.open_timeout = open_timeout if open_timeout
          connection.read_timeout = read_timeout if read_timeout

          begin
            connection.start
          rescue Errno::ECONNREFUSED, Net::OpenTimeout => error
            error_message = "Failed to establish HTTP connection (#{log_attributes}, Error: #{error.class})"
            logger.error error_message
            raise ConnectionError, error
          end

          logger.debug(tag: :db_connection) { "Established HTTP connection to EventStore (#{log_attributes})" }

          if block
            begin
              block.(connection)
            ensure
              logger.debug(tag: :db_connection) { "Terminated HTTP connection to EventStore (#{log_attributes})" }

              connection.finish
            end
          end

          connection
        end

        def log_attributes
          "Host: #{host}, Port: #{port}, OpenTimeout: #{open_timeout.inspect}, ReadTimeout: #{read_timeout.inspect}"
        end

        ConnectionError = Class.new StandardError
      end
    end
  end
end
