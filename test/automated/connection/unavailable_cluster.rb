require_relative '../automated_init'

context "Session Connects To EventStore Cluster, Entire Cluster Is Unavailable" do
  hostname = Controls::Settings::Cluster.hostname
  ip_address_list = Controls::Settings::Cluster::Unavailable::IPAddress.list

  connect = EventStore::HTTP::Session::Connect.new

  Controls::Settings::Cluster.set connect, hostname: hostname
  connect.resolve_host.set hostname, ip_address_list

  test "Connection error is raised" do
    assert proc { connection = connect.() } do
      raises_error? EventStore::HTTP::Session::Connect::ConnectionError
    end
  end
end
