require_relative '../../../automated_init'

context "Write" do
  context "Event" do
    context "Expected Version" do
      stream_name = Controls::StreamName.example

      write_event_1 = Controls::EventData::Write.example

      position = EventSource::EventStore::HTTP::Write.(write_event_1, stream_name)

      write_event_2 = Controls::EventData::Write.example

      EventSource::EventStore::HTTP::Write.(write_event_2, stream_name, expected_version: position)

      read_event, * = EventSource::EventStore::HTTP::Get.(stream_name, position: position + 1)

      test "Got the event that was written" do
        assert(read_event.data == write_event_2.data)
      end
    end
  end
end
