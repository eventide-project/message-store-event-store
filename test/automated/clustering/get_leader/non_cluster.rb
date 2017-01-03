require_relative '../../automated_init'

context "Get Leader, Non-Clustered EventStore" do
  host = Controls::Settings.hostname

  get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build

  resolve_host = SubstAttr::Substitute.(:resolve_host, get_leader)
  resolve_host.set host, Controls::Settings::NonCluster.ip_address

  ip_address = get_leader.()

  test "IP address of solitary EventStore service is returned" do
    assert ip_address == Controls::Settings::NonCluster.ip_address
  end
end
