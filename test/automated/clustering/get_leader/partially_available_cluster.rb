require_relative '../../automated_init'

context "Get Leader When Some EventStore Cluster Nodes Are Unavailable" do
  host = Controls::Settings.hostname

  settings = Controls::Settings.example host: host, read_timeout: 0.1, open_timeout: 0.1
  connect = EventSource::EventStore::HTTP::Connect.build settings

  leader_ip_address, available_ip_address, * = Controls::Cluster::Members.get

  context "EventStore is not running on first IP address returned" do
    unavailable_ip_address = Controls::Settings::IPAddress.unavailable

    get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build connect

    resolve_host = SubstAttr::Substitute.(:resolve_host, get_leader)
    resolve_host.set host, [unavailable_ip_address, available_ip_address]

    ip_address = get_leader.()

    test "Leader IP address is returned" do
      assert ip_address == leader_ip_address
    end
  end

  context "First IP address returned is not routable" do
    unavailable_ip_address = Controls::Settings::IPAddress.non_routable

    get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build connect

    resolve_host = SubstAttr::Substitute.(:resolve_host, get_leader)
    resolve_host.set host, [unavailable_ip_address, available_ip_address]

    ip_address = get_leader.()

    test "Leader IP address is returned" do
      assert ip_address == leader_ip_address
    end
  end

  context "First IP address returned is not a member of a cluster" do
    unavailable_ip_address = Controls::Settings::IPAddress.available

    get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build connect

    resolve_host = SubstAttr::Substitute.(:resolve_host, get_leader)
    resolve_host.set host, [unavailable_ip_address, available_ip_address]

    ip_address = get_leader.()

    test "Leader IP address is returned" do
      assert ip_address == leader_ip_address
    end
  end
end
