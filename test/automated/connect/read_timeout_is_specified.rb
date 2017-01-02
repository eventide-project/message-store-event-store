require_relative '../automated_init'

context "Connecting To EventStore, Read Timeout Is Specified" do
  settings = Controls::Settings.example read_timeout: true

  connect = EventSource::EventStore::HTTP::Connect.build settings

  connection = connect.()

  test "Active connection to EventStore is returned" do
    control_read_timeout = Controls::Settings::ReadTimeout.example

    assert connection do
      settings? read_timeout: control_read_timeout
    end
  end
end
