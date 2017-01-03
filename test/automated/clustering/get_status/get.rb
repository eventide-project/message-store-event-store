require_relative '../../automated_init'

context "Get Cluster Status From Gossip Endpoint" do
  ip_address = Controls::Settings::Cluster::IPAddress.example

  settings = Controls::Settings.example ip_address: ip_address
  connect = EventSource::EventStore::HTTP::Connect.build settings

  get = EventSource::EventStore::HTTP::Clustering::GetStatus.build connect

  cluster_status = get.()

  test "IP address of current cluster leader is returned" do
    leader_ip_address, * = Controls::Cluster::Members.get

    assert cluster_status.leader_ip_address == leader_ip_address
  end
end
