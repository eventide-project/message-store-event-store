require_relative '../automated_init'

context "Session Connects To Non-Clustered EventStore By Hostname" do
  context "EventStore is available" do
    hostname = Controls::Settings.hostname
    ip_address = Controls::Settings.ip_address

    connect = EventStore::HTTP::Connect.new

    Controls::Settings.set connect, hostname: hostname

    connect.resolve_host.set hostname, ip_address

    Telemetry.configure connect
    telemetry_sink = EventStore::HTTP::Connect.register_telemetry_sink connect

    connection = connect.()

    test "Net::HTTP connection is returned" do
      assert connection.instance_of?(Net::HTTP)
    end

    test "IP address resolved from host specified in settings is used" do
      assert connection.address == ip_address
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

  context "EventStore is unavailable" do
    hostname = Controls::Settings::EventStoreUnavailable.hostname
    ip_address = Controls::Settings::EventStoreUnavailable.ip_address

    connect = EventStore::HTTP::Connect.new

    Controls::Settings.set connect, hostname: hostname

    connect.resolve_host.set hostname, ip_address

    test "Connection error is raised" do
      assert proc { connect.() } do
        raises_error? EventStore::HTTP::Connect::ConnectionError
      end
    end
  end

  context "Hostname cannot be resolved to an IP address" do
    hostname = Controls::Settings::NameResolutionFailure.hostname

    connect = EventStore::HTTP::Connect.new

    Controls::Settings.set connect, hostname: hostname

    test "Connection error is raised" do
      assert proc { connect.() } do
        raises_error? EventStore::HTTP::Connect::ConnectionError
      end
    end
  end
end
