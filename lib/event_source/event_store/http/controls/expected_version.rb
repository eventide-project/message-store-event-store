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
              EventSource::NoStream.name
            end

            module Header
              def self.example
                EventSource::NoStream.version.to_s
              end
            end
          end
        end
      end
    end
  end
end
