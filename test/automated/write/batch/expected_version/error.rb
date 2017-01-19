require_relative '../../../automated_init'

context "Write" do
  context "Batch" do
    context "Expected Version" do
      context "Does not match the stream version" do
        stream_name = Controls::StreamName.example

        write_event = Controls::EventData::Write.example
        position = EventSource::EventStore::HTTP::Write.(write_event, stream_name)

        incorrect_stream_version = position  + 1

        write_event_1 = Controls::EventData::Write.example
        write_event_2 = Controls::EventData::Write.example

        batch = [write_event_1, write_event_2]

        erroneous = proc {
          EventSource::EventStore::HTTP::Write.(
            batch,
            stream_name,
            expected_version: incorrect_stream_version
          )
        }

        test "Is an error" do
          assert erroneous do
            raises_error? EventSource::ExpectedVersion::Error
          end
        end

        context "Events" do
          2.times do |i|
            read_event, * = EventSource::EventStore::HTTP::Get.(stream_name, position: i + 1, batch_size: 1)

            test "Event #{i + 1} not written" do
              assert(read_event.nil?)
            end
          end
        end
      end
    end
  end
end
