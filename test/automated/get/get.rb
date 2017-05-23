require_relative '../automated_init'

context "Get" do
  write_message = Controls::MessageData::Write.example

  stream_name = Controls::Write.(write_message)

  read_message, * = MessageStore::EventStore::Get.(stream_name)

  context "Retrieved message" do
    test "ID" do
      assert read_message.id == write_message.id
    end

    test "Type" do
      assert read_message.type == Controls::MessageData.type
    end

    test "Data" do
      assert read_message.data == write_message.data
    end

    test "Metadata" do
      assert read_message.metadata == write_message.metadata
    end

    test "Stream name" do
      assert read_message.stream_name == stream_name
    end

    test "Position" do
      assert read_message.position == 0
    end

    test "Global position" do
      assert read_message.global_position == 0
    end

    test "Recorded time" do
      assert read_message.time.is_a?(Time)
    end
  end
end
