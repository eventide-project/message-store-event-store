require_relative '../automated_init'

context "Connecting To EventStore By Hostname" do
  hostname = 'localhost'

  settings = Controls::Settings.example hostname: hostname

  connect = EventSource::EventStore::HTTP::Connect.build settings

  connection = connect.()

  test "Active connection to EventStore is returned" do
    assert connection do
      connected?(
        host: hostname,
        port: settings.get(:port)
      )
    end
  end
end
