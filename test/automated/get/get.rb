require_relative '../automated_init'

context "Get" do
  write_event = Controls::EventData::Write.example

  stream_name = Controls::Write.(write_event)

  read_event, * = EventSource::EventStore::HTTP::Get.(stream_name)

  context "Retrieved event" do
    test "ID" do
      assert read_event.id == write_event.id
    end

    test "Type" do
      assert read_event.type == Controls::EventData.type
    end

    test "Data" do
      assert read_event.data == write_event.data
    end

    test "Metadata" do
      assert read_event.metadata == write_event.metadata
    end

    test "Stream name" do
      assert read_event.stream_name == stream_name
    end

    test "Position" do
      assert read_event.position == 0
    end

    test "Global position" do
      assert read_event.global_position == 0
    end

    test "Recorded time" do
      assert read_event.time.is_a?(Time)
    end
  end
end
