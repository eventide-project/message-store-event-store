require_relative '../automated_init'

context "Put and Get" do
  stream_name = Controls::StreamName.example
  write_event = Controls::EventData::Write.example

  EventSource::EventStore::HTTP::Put.(write_event, stream_name)

  read_event, * = EventSource::EventStore::HTTP::Get.(stream_name)

  context "Got the event that was written" do
    test "ID" do
      assert read_event.id == write_event.id
    end

    test "Type" do
      assert read_event.type == write_event.type
    end

    test "Data" do
      assert read_event.data == write_event.data
    end

    test "Metadata" do
      assert read_event.metadata == write_event.metadata
    end
  end
end
