require_relative '../automated_init'

context "Put and Get" do
  stream_name = Controls::StreamName.example
  write_message = Controls::MessageData::Write.example

  MessageStore::EventStore::Put.(write_message, stream_name)

  read_message, * = MessageStore::EventStore::Get.(stream_name)

  context "Got the message that was written" do
    test "ID" do
      assert read_message.id == write_message.id
    end

    test "Type" do
      assert read_message.type == write_message.type
    end

    test "Data" do
      assert read_message.data == write_message.data
    end

    test "Metadata" do
      assert read_message.metadata == write_message.metadata
    end
  end
end
