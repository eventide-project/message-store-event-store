require_relative '../automated_init'

context "Read" do
  context "Cycle maximum milliseconds" do
    stream_name = Controls::StreamName.example

    context "Is not set" do
      cycle = Cycle.build maximum_milliseconds: nil

      read = EventSource::EventStore::HTTP::Read.build stream_name, cycle: cycle

      test "Long polling is not enabled" do
        refute read.get do
          long_poll_enabled?
        end
      end
    end

    context "Is set" do
      cycle = Cycle.build maximum_milliseconds: 2222, timeout_milliseconds: 1

      read = EventSource::EventStore::HTTP::Read.build stream_name, cycle: cycle

      test "Long polling is enabled" do
        assert read.get do
          long_poll_enabled?
        end
      end

      test "Long poll duration is set to the next whole second" do
        assert read.get do
          long_poll_enabled? 3
        end
      end
    end
  end
end
