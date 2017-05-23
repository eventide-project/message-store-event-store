require_relative '../../../automated_init'

context "Write" do
  context "Event" do
    context "Expected Version" do
      context "Does not match the stream version" do
        stream_name = Controls::StreamName.example

        write_event = Controls::EventData::Write.example
        position = MessageStore::EventStore::Write.(write_event, stream_name)

        incorrect_stream_version = position  + 1

        erroneous = proc {
          MessageStore::EventStore::Write.(
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

        context "Event" do
          read_event, * = MessageStore::EventStore::Get.(
            stream_name,
            position: incorrect_stream_version,
            batch_size: 1
          )

          test "Is not written" do
            assert(read_event.nil?)
          end
        end
      end
    end
  end
end
