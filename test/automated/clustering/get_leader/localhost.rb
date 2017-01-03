require_relative '../../automated_init'

context "Get Leader, Host Setting Is Set To Localhost" do
  host = 'localhost'

  get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build host: host

  test "Host is resolved to loopback address" do
    assert get_leader.() == '127.0.0.1'
  end
end
