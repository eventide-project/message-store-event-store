require_relative '../automated_init'

context "Put" do
  context "Stream Position Increases with Subsequent Writes" do
    stream_name = Controls::StreamName.example
    write_event = Controls::EventData::Write.example

    position_1 = EventSource::EventStore::HTTP::Put.(write_event, stream_name)
    position_2 = EventSource::EventStore::HTTP::Put.(write_event, stream_name)

    test "First version is one less than the second version" do
      assert position_1 == position_2.pred
    end
  end
end
