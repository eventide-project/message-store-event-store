require_relative '../../automated_init'

context "Put" do
  context "No stream" do
    context "For a stream that doesn't exist" do
      stream_name = Controls::StreamName.example

      write_message = Controls::MessageData::Write.example

      location = MessageStore::EventStore::Put.(
        write_message,
        stream_name,
        expected_version: MessageStore::NoStream.name
      )

      test "Initial stream position is returned" do
        assert location == 0
      end
    end
  end
end
