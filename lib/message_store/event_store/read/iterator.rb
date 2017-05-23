module MessageStore
  module EventStore
    class Read
      class Iterator
        include MessageStore::Read::Iterator

        def last_position
          batch.last.global_position
        end
      end
    end
  end
end
