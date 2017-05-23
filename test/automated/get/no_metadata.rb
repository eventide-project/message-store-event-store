require_relative '../automated_init'

context "Get, Message Has No Metadata" do
  write_message = Controls::MessageData::Write.example metadata: :none

  stream_name = Controls::Write.(write_message)

  read_message, * = MessageStore::EventStore::Get.(stream_name)

  context "Retrieved message" do
    test "Metadata is not set" do
      assert read_message.metadata == nil
    end
  end
end
