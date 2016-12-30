require_relative '../automated_init'

context "Session Connects To EventStore At Specified Host" do
  host = Controls::Settings.ip_address
  connect = EventStore::HTTP::Connect.new

  Controls::Settings.set connect

  Telemetry.configure connect
  telemetry_sink = EventStore::HTTP::Connect.register_telemetry_sink connect

  connection = connect.(host)

  test "Net::HTTP connection is returned" do
    assert connection.instance_of?(Net::HTTP)
  end

  test "Connection is made to specified host" do
    assert connection.address == host
  end

  test "Port specified in settings is used" do
    assert connection.port == Controls::Settings.port
  end

  test "Leader is not queried" do
    refute telemetry_sink do
      recorded_leader_queried?
    end
  end
end
