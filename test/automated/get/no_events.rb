require_relative '../automated_init'

context "Get" do
  context "No events" do
    stream_name = Controls::StreamName.example

    batch = MessageStore::EventStore::Get.(stream_name)

    test "Empty array" do
      assert batch == []
    end
  end
end
