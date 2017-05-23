require_relative '../automated_init'

context "Get Last" do
  write_message_1 = Controls::MessageData::Write.example
  write_message_2 = Controls::MessageData::Write.example

  stream_name = Controls::Write.([write_message_1, write_message_2])

  last_message = MessageStore::EventStore::Get::Last.(stream_name)

  context "Is the last message that was written" do
    test "Type" do
      assert last_message.type == write_message_2.type
    end

    test "Position" do
      assert last_message.position == 1
    end

    test "Data" do
      assert last_message.data == write_message_2.data
    end

    test "Metadata" do
      assert last_message.metadata == write_message_2.metadata
    end
  end
end
