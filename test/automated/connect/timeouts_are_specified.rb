require_relative '../automated_init'

context "Connecting To EventStore, Timeouts Are Specified" do
  settings = Controls::Settings.example open_timeout: true, read_timeout: true

  connect = EventSource::EventStore::HTTP::Connect.build settings

  connection = connect.()

  test "Read timeout" do
    assert connection do
      read_timeout == Controls::Settings::Timeout.read
    end
  end

  test "Open timeout" do
    assert connection do
      open_timeout == Controls::Settings::Timeout.open 
    end
  end
end
