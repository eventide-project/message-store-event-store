require_relative '../../automated_init'

context "Put" do
  context "Expected version" do
    context "Does not match the stream version" do
      stream_version = 1
      incorrect_stream_version = stream_version + 1

      stream_name = Controls::Write.(instances: stream_version + 1)

      write_message = Controls::MessageData::Write.example

      erroneous = proc {
        MessageStore::EventStore::Put.(
          write_message,
          stream_name,
          expected_version: incorrect_stream_version
        )
      }

      test "Is an error" do
        assert erroneous do
          raises_error? MessageStore::ExpectedVersion::Error
        end
      end
    end
  end
end
