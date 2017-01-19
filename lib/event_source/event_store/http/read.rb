module EventSource
  module EventStore
    module HTTP
      class Read
        include EventSource::Read

        def configure(batch_size: nil, precedence: nil, session: nil)
          Get.configure(
            self,
            batch_size: batch_size,
            precedence: precedence,
            session: session
          )
        end
      end
    end
  end
end
