require_relative '../../automated_init'

context "Get Leader When All EventStore Cluster Nodes Are Unavailable" do
  host = Controls::Settings::Cluster.hostname

  settings = Controls::Settings.example host: host, read_timeout: 0.1, open_timeout: 0.1
  connect = EventSource::EventStore::HTTP::Connect.build settings

  unavailable_ip_address_1 = Controls::Settings::IPAddress.unavailable cluster_member: 1
  unavailable_ip_address_2 = Controls::Settings::IPAddress.unavailable cluster_member: 2

  get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build connect

  resolve_host = SubstAttr::Substitute.(:resolve_host, get_leader)
  resolve_host.set host, [unavailable_ip_address_1, unavailable_ip_address_2]

  test "No leader error is raised" do
    assert proc { get_leader.() } do
      raises_error? EventSource::EventStore::HTTP::Clustering::GetLeader::NoLeaderError
    end
  end
end
