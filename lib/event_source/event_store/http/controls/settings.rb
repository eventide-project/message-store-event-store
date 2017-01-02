module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          def self.example(hostname: nil, ip_address: nil, read_timeout: nil)
            ip_address = self.ip_address if ip_address == true

            if ip_address.nil?
              hostname ||= self.hostname
            else
              hostname ||= ip_address
            end

            if read_timeout == true
              read_timeout = ReadTimeout.example
            end

            data = {
              :host => hostname,
              :port => port
            }

            data[:read_timeout] = read_timeout if read_timeout

            EventStore::HTTP::Settings.build data
          end

          def self.set(receiver, hostname: nil, ip_address: nil)
            settings = example hostname: hostname, ip_address: ip_address

            settings.set receiver
          end

          def self.hostname
            'localhost'
          end

          def self.ip_address
            '127.0.0.1'
          end

          def self.port
            2113
          end
        end
      end
    end
  end
end
