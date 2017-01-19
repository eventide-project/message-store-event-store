require_relative '../automated_init'

context "Get" do
  context "Precedence" do
    stream_name = Controls::Write.(instances: 3)

    context "Ascending" do
      events = EventSource::EventStore::HTTP::Get.(stream_name, precedence: :asc)

      first_event_position = events.first.position

      test "First event written is first in the list of results" do
        assert first_event_position == 0
      end
    end

    context "Descending" do
      events = EventSource::EventStore::HTTP::Get.(stream_name, precedence: :desc)

      first_event_position = events.first.position

      test "First event written is last in the list of results" do
        assert first_event_position == 2
      end
    end
  end
end
