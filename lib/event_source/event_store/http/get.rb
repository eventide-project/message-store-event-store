module EventSource
  module EventStore
    module HTTP
      class Get
        include Log::Dependency

        dependency :request, Request::Get

        def self.build(session: nil)
          instance = new
          Request::Get.configure instance, session: session
          instance
        end
      end
    end
  end
end
