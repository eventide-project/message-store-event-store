require_relative '../automated_init'

context "Session Connects To EventStore (Non-Cluster)" do
  session = EventSource::EventStore::HTTP::Session.build

  connection = session.connection

  test "Connection is made to cluster leader" do
    assert connection.address == Controls::IPAddress.example
  end
end
