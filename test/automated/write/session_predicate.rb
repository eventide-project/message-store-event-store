require_relative '../automated_init'

context "Write" do
  context "Session predicate" do
    session = EventSource::EventStore::HTTP::Session.build

    write = EventSource::EventStore::HTTP::Write.build session: session

    context "Writer session" do
      test "Is true" do
        assert write do
          session? session
        end
      end
    end

    context "Other session" do
      other_session = EventSource::EventStore::HTTP::Session.build

      test "Is false" do
        refute write do
          session? other_session
        end
      end
    end
  end
end
