require_relative '../../automated_init'

context "Put" do
  context "Expected version" do
    stream_version = 1

    stream_name = Controls::Write.(instances: stream_version + 1)

    write_event = Controls::EventData::Write.example

    position = MessageStore::EventStore::Put.(
      write_event,
      stream_name,
      expected_version: stream_version
    )

    test "Position following expected version is returned" do
      assert position == stream_version + 1
    end
  end
end
