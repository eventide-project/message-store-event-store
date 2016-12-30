require_relative '../automated_init'

context "Session Connects To EventStore Cluster, First Address Returned By DNS Is Unavailable" do
  hostname = Controls::Settings::Cluster.hostname
  ip_address_list = Controls::Settings::Cluster::PartiallyAvailable::IPAddress.list

  connect = EventStore::HTTP::Connect.new

  Controls::Settings::Cluster.set connect, hostname: hostname
  connect.resolve_host.set hostname, ip_address_list

  Telemetry.configure connect
  telemetry_sink = EventStore::HTTP::Connect.register_telemetry_sink connect

  connection = connect.()

  test "Net::HTTP connection is returned" do
    assert connection.instance_of?(Net::HTTP)
  end

  test "IP address of second address is returned" do
    second_ip_address = Controls::Settings::Cluster::IPAddress.example 2

    assert connection.address == second_ip_address
  end

  test "Port specified in settings is used" do
    assert connection.port == Controls::Settings.port
  end

  test "Connection to first address is closed" do
    first_ip_address = Controls::Settings::Cluster::IPAddress.example 2

    assert telemetry_sink do
      recorded_connected? do |record|
        host = record.data.host
        net_http = record.data.net_http

        host == first_ip_address and !net_http.active?
      end
    end
  end
end
