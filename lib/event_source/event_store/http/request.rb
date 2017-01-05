module EventSource
  module EventStore
    module HTTP
      class Request
        include Log::Dependency

        configure :request

        dependency :session, Session

        def self.build(session: nil)
          instance = new
          Session.configure instance, session: session
          instance
        end

        abstract :call

        abstract :media_type

        def headers
          @headers ||= {}
        end
      end
    end
  end
end
