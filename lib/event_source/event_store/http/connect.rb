module EventSource
  module EventStore
    module HTTP
      class Session
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
            if Resolv::AddressRegex.match host
              ip_address_list = [host]
            else
              ip_address_list = resolve_host.(host)
            end

            ip_address_list.each do |ip_address|
              net_http = try_connect ip_address

              return net_http if net_http
            end

            error_message = "Could not connect to EventStore (Host: #{host}, Port: #{port})"
            logger.error error_message
            raise ConnectionError, error_message
          end

          def try_connect(ip_address)
            net_http = Net::HTTP.new ip_address, port
            net_http.read_timeout = read_timeout if read_timeout

            begin
              net_http.start
            rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL => error
              logger.warn "Could not connect to EventStore (Host: #{host}, Port: #{port}, Error: #{error.class})"
              return nil
            end

            net_http
          end

          ConnectionError = Class.new StandardError
        end
      end
    end
  end
end
