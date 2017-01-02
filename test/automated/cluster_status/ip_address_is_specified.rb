require_relative '../automated_init'

context "Get Cluster Status From Gossip Endpoint, IP Address Is Specified" do
  leader_ip_address, follower_ip_address, _ = Controls::Cluster::Members.get

  settings = Controls::Settings::Cluster.example
  connect = EventSource::EventStore::HTTP::Connect.build settings

  get = EventSource::EventStore::HTTP::ClusterStatus::Get.build connect

  cluster_status = get.(follower_ip_address)

  test "IP address of current cluster leader is returned" do

    assert cluster_status.leader_ip_address == leader_ip_address
  end
end
