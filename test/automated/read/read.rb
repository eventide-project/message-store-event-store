require_relative '../automated_init'

context "Read" do
  stream_name = Controls::Write.(instances: 3)

  batch = []

  MessageStore::EventStore::Read.(stream_name, batch_size: 2) do |event_data|
    batch << event_data
  end

  test "Reads batches of events" do
    assert batch.count == 3
  end

  test "Events are returned in the order they were written" do
    assert batch[0].position == 0
    assert batch[1].position == 1
    assert batch[2].position == 2
  end
end
