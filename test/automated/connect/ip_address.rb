require_relative '../automated_init'

context "Connecting To EventStore By IP Address" do
  settings = Controls::Settings.example ip_address: true

  connect = EventSource::EventStore::HTTP::Connect.build settings

  connection = connect.()

  test "Active connection to EventStore is returned" do
    assert connection do
      connected?(
        host: settings.get(:host),
        port: settings.get(:port)
      )
    end
  end
end
