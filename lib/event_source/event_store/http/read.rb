module EventSource
  module EventStore
    module HTTP
      class Read
        include EventSource::Read

        def configure(session: nil)
          Iterator.configure(self, stream_name, position: position)
          Get.configure(self.iterator, batch_size: batch_size, session: session)
        end
      end
    end
  end
end
