module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module NonCluster
            module Available
              def self.example(ip_address: nil)
                if ip_address
                  ip_address = IPAddress.example if ip_address == true
                  hostname = ip_address
                else
                  hostname = Hostname.example
                end

                Settings.example hostname: hostname
              end

              def self.set(receiver, ip_address: nil)
                settings = example ip_address: ip_address
                settings.set receiver
              end

              module Hostname
                def self.example
                  'eventstore.example'
                end
              end

              module IPAddress
                def self.example
                  '127.0.0.1'
                end
              end
            end

            module Unavailable
              def self.example(ip_address: nil)
                if ip_address
                  ip_address = IPAddress.example if ip_address == true
                  hostname = ip_address
                else
                  hostname = Hostname.example
                end

                Settings.example hostname: hostname
              end

              def self.set(receiver, ip_address: nil)
                settings = example ip_address: ip_address
                settings.set receiver
              end

              module Hostname
                def self.example
                  'eventstore-unavailable.example'
                end
              end

              module IPAddress
                def self.example
                  '127.0.0.2'
                end

                module NotAvailable
                  def self.example
                    '127.0.0.3'
                  end
                end
              end
            end

            module Unknown
              def self.example
                hostname = Hostname.example

                Settings.example hostname: hostname
              end

              def self.set(receiver)
                settings = example
                settings.set receiver
              end

              module Hostname
                def self.example
                  'eventstore-unknown.example'
                end
              end
            end
          end
        end
      end
    end
  end
end
