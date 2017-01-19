module EventSource
  module EventStore
    module HTTP
      class Get
        module Assertions
          def long_poll_enabled?(value=nil)
            duration = read_stream.long_poll_duration

            if duration.nil?
              false
            elsif value.nil?
              true
            else
              duration == value
            end
          end
        end
      end
    end
  end
end
