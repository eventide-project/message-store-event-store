require_relative '../automated_init'

context "Session Connects To EventStore Cluster" do
  settings = Controls::Settings::Cluster.example

  session = EventSource::EventStore::HTTP::Session.build settings
  session.disable_leader_detection = false

  telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink session

  connection = session.establish_connection

  test "Connection is established with cluster leader" do
    assert connection.address == Controls::IPAddress::Cluster::Leader.get
  end

  context "Telemetry" do
    test "Leader status was queried" do
      assert telemetry_sink.recorded_leader_status_queried?
    end

    test "Leader status query was successful" do
      assert telemetry_sink.leader_status_query_successful?
    end

    test "Leader status query did not fail" do
      refute telemetry_sink.leader_status_query_failed?
    end

    test "Connection is established" do
      assert telemetry_sink.recorded_connection_established?
    end
  end
end
