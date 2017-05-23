require_relative '../automated_init'

context "Get Last" do
  context "No events" do
    stream_name = Controls::StreamName.example

    last_event = MessageStore::EventStore::Get::Last.(stream_name)

    test "Is nil" do
      assert last_event == nil
    end
  end
end
