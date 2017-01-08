module EventSource
  module EventStore
    module HTTP
      module Controls
        module StreamName
          def self.example(*arguments)
            EventSource::Controls::StreamName.example *arguments
          end

          module Category
            def self.example
              Stream::Category.example.name
            end
          end
        end
      end
    end
  end
end
