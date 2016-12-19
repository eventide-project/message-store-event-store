require_relative '../test_init'

def report_operations_per_second(operations, elapsed_time)
  writes_per_second = Rational(operations, elapsed_time)

  comment ' '
  comment "Operations: #{operations}"
  comment "Elapsed time: %0.2fs" % elapsed_time
  comment "Throughput: %0.2f ops/sec" % writes_per_second
end
