module EventSource
  module EventStore
    module HTTP
      module Controls
        module ExpectedVersion
          def self.example
            11
          end

          module Header
            def self.example
              '11'
            end
          end

          module NoStream
            def self.example
              :no_stream
            end

            module Header
              def self.example
                '-1'
              end
            end
          end
        end
      end
    end
  end
end
