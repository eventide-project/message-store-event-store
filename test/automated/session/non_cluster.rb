require_relative '../automated_init'

context "Session Connects To EventStore (Non-Cluster)" do
  settings = Controls::Settings.example
  settings.data.read_timeout = 0.1

  session = EventSource::EventStore::HTTP::Session.build settings

  connection = session.connection

  test "Connection is established" do
    assert connection.address == Controls::IPAddress.example
  end
end
