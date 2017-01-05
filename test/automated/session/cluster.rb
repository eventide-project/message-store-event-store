require_relative '../automated_init'

context "Session Connects To EventStore Cluster" do
  settings = Controls::Settings::Cluster.example

  session = EventSource::EventStore::HTTP::Session.build settings

  connection = session.connection

  test "Connection is made to cluster leader" do
    assert connection.address == Controls::IPAddress::Cluster::Leader.get
  end
end
