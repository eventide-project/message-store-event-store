require_relative '../../automated_init'

context "Get Leader, Clustered EventStore" do
  host = Controls::Settings::Cluster.hostname

  leader_ip_address, *follower_ip_addresses = Controls::Cluster::Members.get

  context "First IP address returned by DNS query is cluster leader" do
    dns_response = [leader_ip_address, *follower_ip_addresses]

    get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build host: host

    resolve_host = SubstAttr::Substitute.(:resolve_host, get_leader)
    resolve_host.set host, dns_response

    ip_address = get_leader.()

    test "Leader IP address is returned" do
      assert ip_address == leader_ip_address
    end
  end

  context "First IP address returned by DNS query is a cluster follower" do
    dns_response = [*follower_ip_addresses, leader_ip_address]

    get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build host: host

    resolve_host = SubstAttr::Substitute.(:resolve_host, get_leader)
    resolve_host.set host, dns_response

    ip_address = get_leader.()

    test "Leader IP address is returned" do
      assert ip_address == leader_ip_address
    end
  end
end
