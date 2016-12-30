module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          def self.example(hostname: nil, ip_address: nil)
            ip_address = self.ip_address if ip_address == true

            if ip_address.nil?
              hostname ||= Hostname.example
            else
              hostname ||= ip_address
            end

            data = {
              :host => hostname,
              :port => port
            }

            EventStore::HTTP::Settings.build data
          end

          def self.set(receiver, hostname: nil, ip_address: nil)
            settings = example hostname: hostname, ip_address: ip_address

            settings.set receiver
          end

          def self.hostname
            'eventstore.example'
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
