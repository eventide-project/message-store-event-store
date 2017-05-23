require_relative '../automated_init'

context "Put" do
  context "Returns stream position" do
    stream_name = Controls::StreamName.example

    write_message_1 = Controls::MessageData::Write.example
    write_message_2 = Controls::MessageData::Write.example

    position_1 = MessageStore::EventStore::Put.(write_message_1, stream_name)
    position_2 = MessageStore::EventStore::Put.(write_message_2, stream_name)

    test "First write returns position of first message" do
      assert position_1 == 0
    end

    test "Subsequent write returns position of next message" do
      assert position_2 == 1
    end
  end
end
