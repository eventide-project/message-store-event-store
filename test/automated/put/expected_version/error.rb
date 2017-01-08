require_relative '../../automated_init'

context "Put, Wrong Expected Version Is Supplied" do
  stream_name = Controls::StreamName.example
  write_event = Controls::EventData::Write.example

  position = EventSource::EventStore::HTTP::Put.(write_event, stream_name)

  test "Expected version error is raised" do
    expected_version = position + 1

    assert proc { EventSource::EventStore::HTTP::Put.(write_event, stream_name, expected_version: expected_version) } do
      raises_error? EventSource::ExpectedVersion::Error
    end
  end
end
