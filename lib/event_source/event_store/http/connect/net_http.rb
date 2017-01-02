module EventSource
  module EventStore
    module HTTP
      class Connect
        module NetHTTP
          module Assertions
            def connected?(host: nil, port: nil, &block)
              unless settings? host: host, port: port, &block
                return false
              end

              active?
            end

            def closed?
              not active?
            end

            def settings?(host: nil, port: nil, &block)
              unless host.nil? || address == host
                return false
              end

              unless port.nil? || self.port == port
                return false
              end

              if block
                return block.(self)
              else
                true
              end
            end
          end
        end
      end
    end
  end
end
