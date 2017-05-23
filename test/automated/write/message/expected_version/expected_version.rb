require_relative '../../../automated_init'

context "Write" do
  context "Message" do
    context "Expected Version" do
      stream_name = Controls::StreamName.example

      write_message_1 = Controls::MessageData::Write.example

      position = MessageStore::EventStore::Write.(write_message_1, stream_name)

      write_message_2 = Controls::MessageData::Write.example

      MessageStore::EventStore::Write.(write_message_2, stream_name, expected_version: position)

      read_message, * = MessageStore::EventStore::Get.(stream_name, position: position + 1)

      test "Got the message that was written" do
        assert(read_message.data == write_message_2.data)
      end
    end
  end
end
