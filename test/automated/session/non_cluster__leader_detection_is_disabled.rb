require_relative '../automated_init'

context "Session Connects To Non-Clustered EventStore, Leader Detection Is Disabled" do
  session = EventSource::EventStore::HTTP::Session.build
  session.disable_leader_detection = true

  telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink session

  connection = session.establish_connection

  test "Connection is established" do
    assert connection do
      connected?
    end
  end

  context "Telemetry" do
    test "Leader status was not queried" do
      refute telemetry_sink.recorded_leader_status_queried?
    end
  end
end
