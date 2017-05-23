module MessageStore
  module EventStore
    class Get
      module Assertions
        def self.extended(get)
          get.read_stream.extend(::EventStore::HTTP::Request::Assertions)
        end

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

        def session?(session, strict: nil)
          read_stream.session?(session, strict: strict)
        end
      end
    end
  end
end
