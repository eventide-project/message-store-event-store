require_relative '../../automated_init'

context "Put" do
  context "Metadata" do
    context "Nil" do
      stream_name = Controls::StreamName.example

      write_event = Controls::EventData::Write.example metadata: :none

      position = EventSource::EventStore::HTTP::Put.(write_event, stream_name)

      read_event, * = EventSource::EventStore::HTTP::Get.(stream_name, position: position)

      context "Read metadata" do
        test "Is nil" do
          assert read_event.metadata.nil?
        end
      end
    end
  end
end
