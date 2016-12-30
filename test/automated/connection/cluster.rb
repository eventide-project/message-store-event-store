require_relative '../automated_init'

context "Session Connects To EventStore Cluster" do
  hostname = Controls::Settings::Cluster.hostname
  ip_address_list = Controls::Settings::Cluster::IPAddress.list

  connect = EventStore::HTTP::Connect.new

  Controls::Settings::Cluster.set connect, hostname: hostname

  connect.resolve_host.set hostname, ip_address_list

  Telemetry.configure connect
  telemetry_sink = EventStore::HTTP::Connect.register_telemetry_sink connect

  connection = connect.()

  test "Net::HTTP connection is returned" do
    assert connection.instance_of?(Net::HTTP)
  end

  test "IP address of first address is returned" do
    control_ip_address = Controls::Settings::Cluster::IPAddress.example 1

    assert connection.address == control_ip_address
  end

  test "Port specified in settings is used" do
    assert connection.port == Controls::Settings.port
  end

  test "EventStore is queried for cluster leader" do
    assert telemetry_sink do
      recorded_leader_queried?
    end
  end

  test "Connection used for leader query is closed" do
    assert telemetry_sink do
      recorded_leader_queried? do |record|
        !record.data.net_http.active?
      end
    end
  end
end
