module EventSource
  module EventStore
    module HTTP
      module Controls
        module ExpectedVersion
          def self.example
            11
          end

          module NoStream
            def self.example
              -1
            end
          end
        end
      end
    end
  end
end
