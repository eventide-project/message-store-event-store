require_relative '../../automated_init'

context "Put" do
  context "No stream" do
    context "For a stream that doesn't exist" do
      stream_name = Controls::StreamName.example

      write_event = Controls::EventData::Write.example

      location = EventSource::EventStore::HTTP::Put.(
        write_event,
        stream_name,
        expected_version: EventSource::NoStream.name
      )

      test "Initial stream position is returned" do
        assert location == 0
      end
    end
  end
end
