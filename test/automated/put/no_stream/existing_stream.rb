require_relative '../../automated_init'

context "Put" do
  context "No stream" do
    context "For a stream that exists" do
      stream_name = Controls::Write.(instances: 1)

      write_message = Controls::MessageData::Write.example

      erroneous = proc {
        MessageStore::EventStore::Put.(
          write_message,
          stream_name,
          expected_version: MessageStore::NoStream.name
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
