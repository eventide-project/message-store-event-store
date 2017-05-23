require_relative '../../automated_init'

context "Put" do
  context "Metadata" do
    context "Empty" do
      stream_name = Controls::StreamName.example

      write_message = Controls::MessageData::Write.example metadata: {}

      position = MessageStore::EventStore::Put.(write_message, stream_name)

      read_message, * = MessageStore::EventStore::Get.(stream_name, position: position)

      context "Read metadata" do
        test "Is nil" do
          assert read_message.metadata.nil?
        end
      end
    end
  end
end
