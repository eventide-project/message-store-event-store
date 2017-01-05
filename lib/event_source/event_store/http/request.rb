module EventSource
  module EventStore
    module HTTP
      class Request
        include Log::Dependency

        dependency :session, Session

        def self.build(session: nil)
          instance = new
          Session.configure instance, session: session
          instance
        end

        abstract :call
      end
    end
  end
end
