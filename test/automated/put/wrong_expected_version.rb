require_relative '../automated_init'

context "Put, Wrong Expected Version Is Supplied" do
  stream_name = Controls::StreamName.example
  write_event = Controls::EventData::Write.example

  test "Expected version error is raised" do
    assert proc { EventSource::EventStore::HTTP::Put.(write_event, stream_name, expected_version: 1) } do
      raises_error? EventSource::ExpectedVersion::Error
    end
  end
end
