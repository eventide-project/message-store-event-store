require_relative '../automated_init'

context "Get" do
  context "Starting position" do
    stream_name = Controls::Write.(instances: 2)

    batch = []
    
    MessageStore::EventStore::Read.(stream_name, position: 1, batch_size: 1) do |message_data|
      batch << message_data
    end

    test "Reads from the starting position" do
      assert batch.length == 1
    end
  end
end
