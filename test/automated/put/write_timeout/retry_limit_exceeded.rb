require_relative '../../automated_init'

context "Put, EventStore Times Out During Write" do
  context "Retry limit is exceeded" do
    retry_limit = 3

    stream_name = Controls::StreamName.example
    write_event = Controls::EventData::Write.example

    put = EventSource::EventStore::HTTP::Put.build
    put.retry_limit = retry_limit

    Controls::Request::Post::SimulateWriteTimeout.extend put.request, (retry_limit + 1)

    telemetry_sink = put.class.register_telemetry_sink put

    test "Write timeout error is raised" do
      assert proc { put.(write_event, stream_name) } do
        raises_error? EventSource::EventStore::HTTP::Request::Post::WriteTimeoutError
      end
    end

    context "Retries" do
      (1..retry_limit).each do |_retry|
        test "Retry ##{_retry}" do
          assert telemetry_sink do
            recorded_retry? do |record|
              record.data.retry == _retry
            end
          end
        end
      end
    end
  end
end
