module EventSource
  module EventStore
    module HTTP
      module Controls
        module Session
          module Request
            module RequireLeader
              def self.example
                WriteEvent.example headers: { 'ES-RequireMaster' => 'true' }
              end
            end
          end
        end
      end
    end
  end
end
