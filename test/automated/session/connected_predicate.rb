require_relative '../automated_init'

context "Session, Connected Predicate" do
  session = EventSource::EventStore::HTTP::Session.build

  context "Session has not yet connected" do
    test "False is returned" do
      assert session.connected? == false
    end
  end

  context "Session has been established" do
    session.establish_connection

    test "True is returned" do
      assert session.connected? == true
    end

    test "Net::HTTP session has started" do
      assert session.connection.started?
    end
  end
end
