require_relative '../../automated_init'

context "Put, EventStore Times Out During Write" do
  stream_name = Controls::StreamName.example
  write_event = Controls::EventData::Write.example

  put = EventSource::EventStore::HTTP::Put.build

  Controls::Request::Post::SimulateWriteTimeout.extend put.request

  telemetry_sink = put.class.register_telemetry_sink put

  position = put.(write_event, stream_name)

  test "Event is written" do
    get_response = Controls::Read::Event.(stream_name, position: position)

    assert get_response.code == '200'
  end

  test "Write timeout error is rescued and post is retried" do
    assert telemetry_sink do
      recorded_retry? do |record|
        record.data.error.instance_of? EventSource::EventStore::HTTP::Request::Post::WriteTimeoutError
      end
    end
  end
end
