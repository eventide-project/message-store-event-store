module EventSource
  module EventStore
    module HTTP
      class Connect
        include Log::Dependency

        setting :host
        setting :port
        setting :read_timeout

        dependency :resolve_host, DNS::ResolveHost

        def self.build(settings: nil, namespace: nil)
          settings ||= Settings.instance
          namespace = Array(namespace)

          instance = new
          Settings.set instance, *namespace
          DNS::ResolveHost.configure instance
          instance
        end

        def self.call(**arguments)
          instance = build **arguments
          instance.()
        end

        def call
          logger.trace(tag: :db_connection) { "Connecting to EventStore (#{LogAttributes.get self})" }

          ip_address_list = get_ip_address_list

          ip_address_list.each do |ip_address|
            net_http = try_connect ip_address

            return net_http if net_http
          end

          error_message = "Could not connect to EventStore (Host: #{host}, Port: #{port})"
          logger.error(tag: :db_connection) { error_message }
          raise ConnectionError, error_message
        end

        def get_ip_address_list
          logger.trace(tag: :db_connection) { "Resolving host (#{LogAttributes.get self})" }

          if Resolv::AddressRegex.match host
            ip_address_list = [host]
          else
            ip_address_list = resolve_host.(host)
          end

          logger.debug(tag: :db_connection) { "Host resolved (#{LogAttributes.get self}, IPAddressList: #{ip_address_list * ', '})" }

          ip_address_list
        end

        def try_connect(ip_address)
          logger.trace(tag: :db_connection) { "Attempting connection (Host: #{LogAttributes.get self}, IPAddress: #{ip_address})" }

          net_http = Net::HTTP.new ip_address, port
          net_http.read_timeout = read_timeout if read_timeout

          begin
            net_http.start
          rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL => error
            logger.warn(tag: :db_connection) { "Could not connect to EventStore (#{LogAttributes.get self}, IPAddress: #{ip_address}, Error: #{error.class})" }
            return nil
          end

          logger.info(tag: :db_connection) { "Connected to EventStore (#{LogAttributes.get self}, IPAddress: #{ip_address})" }

          net_http
        end

        module LogAttributes
          def self.get(connect)
            "Host: #{connect.host}, Port: #{connect.port}"
          end
        end

        ConnectionError = Class.new StandardError
      end
    end
  end
end
