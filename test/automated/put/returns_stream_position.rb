require_relative '../automated_init'

context "Put" do
  context "Returns stream position" do
    stream_name = Controls::StreamName.example

    write_event_1 = Controls::EventData::Write.example
    write_event_2 = Controls::EventData::Write.example

    position_1 = MessageStore::EventStore::Put.(write_event_1, stream_name)
    position_2 = MessageStore::EventStore::Put.(write_event_2, stream_name)

    test "First write returns position of first event" do
      assert position_1 == 0
    end

    test "Subsequent write returns position of next event" do
      assert position_2 == 1
    end
  end
end
