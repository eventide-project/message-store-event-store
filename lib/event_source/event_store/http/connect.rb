module EventSource
  module EventStore
    module HTTP
      class Connect
        include Log::Dependency

        setting :host
        setting :port
        setting :read_timeout

        def self.build(settings=nil, namespace: nil, host: nil)
          settings ||= Settings.instance
          namespace = Array(namespace)

          instance = new
          settings.set instance, *namespace, strict: true
          instance.host = host if host
          instance
        end

        def self.call(**arguments, &block)
          instance = build **arguments
          instance.(&block)
        end

        def call(&block)
          logger.trace(tag: :db_connection) { "Establishing HTTP connection to EventStore (Host: #{host}, Port: #{port}, ReadTimeout: #{read_timeout.inspect})" }

          connection = Net::HTTP.new host, port
          connection.read_timeout = read_timeout if read_timeout
          connection.start

          if block
            begin
              block.(connection)
            ensure
              connection.finish
            end
          end

          logger.debug(tag: :db_connection) { "Established HTTP connection to EventStore (Host: #{host}, Port: #{port}, ReadTimeout: #{read_timeout.inspect})" }

          connection
        end
      end
    end
  end
end
