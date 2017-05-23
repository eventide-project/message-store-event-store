require_relative '../automated_init'

context "Get, Event Has No Metadata" do
  write_event = Controls::EventData::Write.example metadata: :none

  stream_name = Controls::Write.(write_event)

  read_event, * = MessageStore::EventStore::Get.(stream_name)

  context "Retrieved event" do
    test "Metadata is not set" do
      assert read_event.metadata == nil
    end
  end
end
