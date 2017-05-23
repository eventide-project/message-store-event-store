require_relative '../automated_init'

context "Get Last" do
  context "No messages" do
    stream_name = Controls::StreamName.example

    last_message = MessageStore::EventStore::Get::Last.(stream_name)

    test "Is nil" do
      assert last_message == nil
    end
  end
end
