require_relative '../automated_init'

context "Connecting To EventStore, Host Is Specified" do
  host = 'localhost'

  settings = Controls::Settings.example hostname: 'example.com'

  connect = EventSource::EventStore::HTTP::Connect.build settings, host: host

  connection = connect.()

  test "Connection is made to specified host argument, not settings" do
    assert connection do
      connected? host: host
    end
  end
end
