require_relative '../../automated_init'

context "Put" do
  context "Expected version" do
    context "Does not match the stream version" do
      stream_version = 1
      incorrect_stream_version = stream_version + 1

      stream_name = Controls::Write.(instances: stream_version + 1)

      write_event = Controls::EventData::Write.example

      erroneous = proc {
        EventSource::EventStore::HTTP::Put.(
          write_event,
          stream_name,
          expected_version: incorrect_stream_version
        )
      }

      test "Is an error" do
        assert erroneous do
          raises_error? EventSource::ExpectedVersion::Error
        end
      end
    end
  end
end
