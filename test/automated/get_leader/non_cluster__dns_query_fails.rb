require_relative '../automated_init'

context "Get Leader, Non-Clustered EventStore Where DNS Query Fails" do
  settings = Controls::Settings::NonCluster.example
  connect = EventSource::EventStore::HTTP::Connect.build settings

  get_leader = EventSource::EventStore::HTTP::GetLeader.build connect

  SubstAttr::Substitute.(:resolve_host, get_leader)

  test "DNS resolution error is raised" do
    assert proc { get_leader.() } do
      raises_error? DNS::ResolveHost::ResolutionError
    end
  end
end
