require_relative '../automated_init'

context "Read" do
  context "Reverse" do
    stream_name = Controls::Write.(instances: 3)

    events = []

    EventSource::EventStore::HTTP::Read.(stream_name, precedence: :desc) do |event|
      events << event
    end

    first_event_position = events.first.position

    test "Last event written is first in the list of results" do
      assert first_event_position == 2
    end
  end
end
