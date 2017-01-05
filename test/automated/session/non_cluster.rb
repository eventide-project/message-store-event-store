require_relative '../automated_init'

context "Session Connects To EventStore (Non-Cluster)" do
  settings = Controls::Settings.example
  settings.data.read_timeout = 0.1

  session = EventSource::EventStore::HTTP::Session.build settings

  telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink session

  connection = session.connection

  test "Connection is established" do
    assert connection.address == Controls::IPAddress.example
  end

  context "Telemetry" do
    test "Leader status was queried" do
      assert telemetry_sink.recorded_leader_status_queried?
    end

    test "Leader status query was not successful" do
      refute telemetry_sink.leader_status_query_successful?
    end

    test "Leader status query failed" do
      assert telemetry_sink.leader_status_query_failed?
    end
  end
end
