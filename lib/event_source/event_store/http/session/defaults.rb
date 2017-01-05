module EventSource
  module EventStore
    module HTTP
      class Session
        module Defaults
          def self.disable_leader_detection
            disabled = ENV['DISABLE_EVENT_STORE_LEADER_DETECTION']

            if /\A(?:on|yes|y|true|1)\z/i.match disabled
              true
            else
              false
            end
          end
        end
      end
    end
  end
end
