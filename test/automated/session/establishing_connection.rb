require_relative '../automated_init'

context "Session Establishes Connection To EventStore" do
  session = EventSource::EventStore::HTTP::Session.build

  telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink session

  connection = session.establish_connection

  test "Connection is active" do
    assert connection.active?
  end

  context "Telemetry" do
    context "Connection established record" do
      record, * = telemetry_sink.connection_established_records

      test "Is recorded" do
        assert record
      end

      test "Host is set" do
        assert record.data.host == Controls::Hostname.example
      end

      test "Port is set" do
        assert record.data.port == Controls::Port.example
      end

      test "Net::HTTP connection is set" do
        assert record.data.connection == connection
      end
    end
  end
end
