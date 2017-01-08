module EventSource
  module EventStore
    module HTTP
      module Iterator
        def continuous?
          return false if cycle.instance_of? Cycle::None

          cycle.timeout_milliseconds.nil?
        end

        def enable_long_poll
          logger.trace { "Enabling long polling (CycleDelay: #{cycle.delay_milliseconds}ms)" }

          duration = Rational(cycle.delay_milliseconds, 1_000).ceil

          get.request.enable_long_poll duration

          logger.debug { "Long polling enabled (CycleDelay: #{cycle.delay_milliseconds}ms, Duration: #{duration})" }
        end
      end
    end
  end
end
