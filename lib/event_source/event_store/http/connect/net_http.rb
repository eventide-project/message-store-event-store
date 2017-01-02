module EventSource
  module EventStore
    module HTTP
      class Connect
        module NetHTTP
          module Assertions
            def connected?(host: nil, port: nil, read_timeout: nil)
              unless settings? host: host, port: port, read_timeout: read_timeout
                return false
              end

              active?
            end

            def closed?
              not active?
            end

            def settings?(host: nil, port: nil, read_timeout: nil)
              unless host.nil? || address == host
                return false
              end

              unless port.nil? || self.port == port
                return false
              end

              unless read_timeout.nil? || self.read_timeout == read_timeout
                return false
              end

              true
            end
          end
        end
      end
    end
  end
end
