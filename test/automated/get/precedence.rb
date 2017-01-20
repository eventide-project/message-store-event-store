require_relative '../automated_init'

context "Get" do
  context "Precedence" do
    stream_name = Controls::Write.(instances: 3)

    context "Ascending" do
      first_event, * = EventSource::EventStore::HTTP::Get.(stream_name, precedence: :asc)

      test "First event written is first in the list of results" do
        assert first_event.position == 0
      end
    end

    context "Descending" do
      context "Position is not set" do
        first_event, * = EventSource::EventStore::HTTP::Get.(stream_name, precedence: :desc)

        test "First event written is last in the list of results" do
          assert first_event.position == 2
        end
      end

      context "Position is set" do
        first_event, * = EventSource::EventStore::HTTP::Get.(stream_name, position: 1, precedence: :desc)

        test "Results start at specified position" do
          assert first_event.position == 1
        end
      end

      context "Stream not found" do
        stream_name = Controls::StreamName.example

        events = EventSource::EventStore::HTTP::Get.(stream_name, precedence: :desc)

        test "No results" do
          assert events == []
        end
      end
    end
  end
end
