module EventSource
  module EventStore
    module HTTP
      class Session
        module Configure
          def configure(receiver, settings=nil, namespace: nil, session: nil, attr_name: nil)
            attr_name ||= :session

            if session.nil?
              instance = build settings, namespace: namespace
            else
              instance = session
            end

            receiver.public_send "#{attr_name}=", instance
            instance
          end
        end
      end
    end
  end
end
