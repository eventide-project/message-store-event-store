require_relative '../automated_init'

context "Connecting To EventStore, Host Setting Is Overridden" do
  host = 'localhost'

  settings = Controls::Settings.example host: 'example.com'

  connect = EventSource::EventStore::HTTP::Connect.build settings, host: host

  connection = connect.()

  test "Connection is made to specified host argument, not settings" do
    assert connection do
      connected? host: host
    end
  end
end
