require_relative '../automated_init'

context "Closing Session" do
  session = EventSource::EventStore::HTTP::Session.build

  context "Session has not been closed" do
    test "Session is active" do
      assert session.active?
    end

    test "Net::HTTP connection is active" do
      assert session.connection do
        active?
      end
    end
  end

  context "Session has been closed" do
    session.close

    test "Session is not active" do
      refute session.active?
    end

    test "Net::HTTP connection is not active" do
      refute session.connection do
        active?
      end
    end
  end
end
