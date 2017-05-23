require_relative '../../automated_init'

context "Put" do
  context "Expected version" do
    stream_version = 1

    stream_name = Controls::Write.(instances: stream_version + 1)

    write_message = Controls::MessageData::Write.example

    position = MessageStore::EventStore::Put.(
      write_message,
      stream_name,
      expected_version: stream_version
    )

    test "Position following expected version is returned" do
      assert position == stream_version + 1
    end
  end
end
