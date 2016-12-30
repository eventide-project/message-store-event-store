require_relative '../automated_init'

context "Session Connects To EventStore Cluster, First Address Returned By DNS Is Unavailable" do
  hostname = Controls::Settings::Cluster.hostname
  ip_address_list = Controls::Settings::Cluster::PartiallyAvailable::IPAddress.list

  connect = EventStore::HTTP::Session::Connect.new

  Controls::Settings::Cluster.set connect, hostname: hostname
  connect.resolve_host.set hostname, ip_address_list

  connection = connect.()

  test "Net::HTTP connection is returned" do
    assert connection.instance_of?(Net::HTTP)
  end

  test "IP address of second address is returned" do
    control_ip_address = Controls::Settings::Cluster::IPAddress.example 2

    assert connection.address == control_ip_address
  end

  test "Port specified in settings is used" do
    assert connection.port == Controls::Settings.port
  end
end
