require_relative '../../automated_init'

context "Get Leader, Host Setting Is Overridden" do
  host = 'some-host'

  get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build host: host

  test "Connect dependency will connect to specified host" do
    assert get_leader.connect do |connect|
      connect.host == host
    end
  end

  test "DNS query will be made against specified host" do
    assert get_leader.host == host
  end
end
