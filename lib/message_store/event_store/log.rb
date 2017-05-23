module MessageStore
  module EventStore
    class Log < ::Log
      def tag!(tags)
        tags << :message_store_event_store
        tags << :message_store
        tags << :library
        tags << :verbose
      end
    end
  end
end
