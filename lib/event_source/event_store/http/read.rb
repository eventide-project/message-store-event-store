module EventSource
  module EventStore
    module HTTP
      class Read
        include EventSource::Read

        def self.build(*)
          instance = super
          instance.configure_long_poll
          instance
        end

        def configure(batch_size: nil, precedence: nil, session: nil)
          Get.configure(
            self,
            batch_size: batch_size,
            precedence: precedence,
            session: session
          )
        end

        def configure_long_poll
          cycle = iterator.cycle

          return if cycle.instance_of? Cycle::None

          maximum_milliseconds = cycle.maximum_milliseconds

          long_poll_duration = Rational(maximum_milliseconds, 1000).ceil

          get.read_stream.enable_long_poll long_poll_duration
        end
      end
    end
  end
end
