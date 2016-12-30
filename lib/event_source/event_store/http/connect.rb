module EventSource
  module EventStore
    module HTTP
      class Connect
        include Log::Dependency

        setting :host
        setting :port
        setting :read_timeout

        dependency :resolve_host, DNS::ResolveHost

        def get_leader
          proc { |net_http| net_http.address }
        end

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

        def call(leader_host=nil)
          logger.trace(tag: :db_connection) { "Connecting to EventStore (#{LogAttributes.get self})" }

          leader_host ||= determine_leader

          if leader_host.nil?
            error_message = "Could not connect to EventStore (#{LogAttributes.get self})"
            logger.error(tag: :db_connection) { error_message }
            raise ConnectionError, error_message
          end

          net_http = connect leader_host

          logger.info(tag: :db_connection) { "Connected to EventStore (#{LogAttributes.get self}, Host: #{net_http.address})" }

          net_http
        end

        def determine_leader
          logger.trace(tag: :db_connection) { "Determining leader (#{LogAttributes.get self})" }

          ip_address_list = get_ip_address_list

          ip_address_list.each do |ip_address|
            net_http = try_connect ip_address

            next if net_http.nil?

            leader_host = get_leader.(net_http)

            logger.trace(tag: :db_connection) { "Leader determined (#{LogAttributes.get self}, LeaderHost: #{leader_host})" }
            return leader_host
          end

          nil
        end

        def get_ip_address_list
          logger.trace(tag: :db_connection) { "Resolving host (#{LogAttributes.get self})" }

          if Resolv::AddressRegex.match host
            ip_address_list = [host]
          else
            begin
              ip_address_list = resolve_host.(host)

            rescue DNS::ResolveHost::ResolutionError => error
              error_message = "Could not connect to EventStore (#{LogAttributes.get self}, Error: #{error.class})"
              logger.error(tag: :db_connection) { error_message }
              raise ConnectionError, error_message
            end
          end

          logger.debug(tag: :db_connection) { "Host resolved (#{LogAttributes.get self}, IPAddressList: #{ip_address_list * ', '})" }

          ip_address_list
        end

        def try_connect(ip_address)
          logger.trace(tag: :db_connection) { "Attempting connection (Host: #{LogAttributes.get self}, IPAddress: #{ip_address})" }

          begin
            net_http = connect ip_address

          rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL => error
            logger.warn(tag: :db_connection) { "Could not connect to EventStore (#{LogAttributes.get self}, IPAddress: #{ip_address}, Error: #{error.class})" }
            return nil
          end

          logger.debug(tag: :db_connection) { "Connected to EventStore (#{LogAttributes.get self}, IPAddress: #{ip_address})" }

          net_http
        end

        def connect(host)
          net_http = Net::HTTP.new host, port
          net_http.read_timeout = read_timeout if read_timeout
          net_http.start
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
