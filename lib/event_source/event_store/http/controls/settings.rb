module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          def self.example(host: nil, ip_address: nil, open_timeout: nil, read_timeout: nil)
            ip_address = self.ip_address if ip_address == true

            if ip_address.nil?
              host ||= hostname
            else
              host ||= ip_address
            end

            if open_timeout == true
              open_timeout = Timeout.open
            end

            if read_timeout == true
              read_timeout = Timeout.read
            end

            data = {
              :host => host,
              :port => port
            }

            data[:read_timeout] = read_timeout if read_timeout
            data[:open_timeout] = open_timeout if open_timeout

            EventStore::HTTP::Settings.build data
          end

          def self.hostname
            'localhost'
          end

          def self.ip_address
            IPAddress.available
          end

          def self.port
            2113
          end
        end
      end
    end
  end
end
