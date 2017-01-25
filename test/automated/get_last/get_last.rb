require_relative '../automated_init'

context "Get Last" do
  write_event_1 = Controls::EventData::Write.example
  write_event_2 = Controls::EventData::Write.example

  stream_name = Controls::Write.([write_event_1, write_event_2])

  last_event = EventSource::EventStore::HTTP::Get::Last.(stream_name)

  context "Is the last event that was written" do
    test "Type" do
      assert last_event.type == write_event_2.type
    end

    test "Position" do
      assert last_event.position == 1
    end

    test "Data" do
      assert last_event.data == write_event_2.data
    end

    test "Metadata" do
      assert last_event.metadata == write_event_2.metadata
    end
  end
end
