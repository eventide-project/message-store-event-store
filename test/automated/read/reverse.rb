require_relative '../automated_init'

context "Read" do
  context "Reverse" do
    context "Page aligned" do
      stream_name = Controls::Write.(instances: 5)

      positions = []

      EventSource::EventStore::HTTP::Read.(stream_name, precedence: :desc, batch_size: 2) do |event|
        positions << event.position
      end

      test "Results are returned in descending order" do
        comment "Event Positions: #{positions * ', '}"

        assert positions == [4, 3, 2, 1, 0]
      end
    end

    context "Non-page aligned" do
      stream_name = Controls::Write.(instances: 4)

      positions = []

      EventSource::EventStore::HTTP::Read.(stream_name, precedence: :desc, batch_size: 2) do |event|
        positions << event.position
      end

      test "Results are returned in descending order" do
        comment "Event Positions: #{positions * ', '}"

        assert positions == [3, 2, 1, 0]
      end
    end
  end
end
