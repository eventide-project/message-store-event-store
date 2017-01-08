require_relative '../../automated_init'

context "Put, Expected Version Is Supplied" do
  stream_name = Controls::StreamName.example
  write_event = Controls::EventData::Write.example

  position = EventSource::EventStore::HTTP::Put.(write_event, stream_name)

  put = EventSource::EventStore::HTTP::Put.build

  telemetry_sink = put.class.register_telemetry_sink put

  put.(write_event, stream_name, expected_version: position)

  get_response = EventStore::HTTP::Connect.() do |http|
    http.request_get(
      "/streams/#{stream_name}/#{position}",
      { 'Accept' => EventSource::EventStore::HTTP::MediaTypes.vnd_event_store_atom_json }
    )
  end

  test "Event is written" do
    assert get_response.code == '200'
  end

  test "Expected version header is set" do
    assert telemetry_sink do
      recorded_post? do |record|
        request = record.data.request

        request['ES-ExpectedVersion'] == position.to_s
      end
    end
  end
end
