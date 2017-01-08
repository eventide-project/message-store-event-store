require_relative '../../automated_init'

context "Put, Expected Version Is No Stream" do
  context "Stream exists" do
    stream_name = Controls::StreamName.example
    write_event = Controls::EventData::Write.example

    EventSource::EventStore::HTTP::Put.(write_event, stream_name)

    put = EventSource::EventStore::HTTP::Put.build

    test "Expected version error is raised" do
      expected_version = EventSource::NoStream.name

      assert proc { EventSource::EventStore::HTTP::Put.(write_event, stream_name, expected_version: expected_version) } do
        raises_error? EventSource::ExpectedVersion::Error
      end
    end
  end
end
