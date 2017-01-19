require_relative '../automated_init'

context "Get" do
  context "Starting position" do
    stream_name = Controls::Write.(instances: 2)

    batch = []
    
    EventSource::EventStore::HTTP::Read.(stream_name, position: 1, batch_size: 1) do |event_data|
      batch << event_data
    end

    test "Reads from the starting position" do
      assert batch.length == 1
    end
  end
end
