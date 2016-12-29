require_relative '../../automated_init'

context "Session Connects To Non-Clustered EventStore By Hostname" do
  context "EventStore is available" do
    connect = EventStore::HTTP::Session::Connect.new

    Controls::Settings::NonCluster::Available.set connect
    Controls::Session::ResolvDNS.configure connect

    connection = connect.()
    p connection

    test "Net::HTTP connection is returned" do
      assert connection.instance_of?(Net::HTTP)
    end

    test "Host specified in settings is used" do
      assert connection.address == Controls::Settings::NonCluster::Available::IPAddress.example
    end

    test "Port specified in settings is used" do
      assert connection.port == Controls::Settings::Port.example
    end
  end

  context "EventStore is unavailable" do
    connect = EventStore::HTTP::Session::Connect.new

    Controls::Settings::NonCluster::Unavailable.set connect
    Controls::Session::ResolvDNS.configure connect

    test "Connection error is raised" do
      assert proc { connect.() } do
        raises_error? EventStore::HTTP::Session::Connect::ConnectionError
      end
    end
  end

  context "Hostname cannot be resolved to an IP address" do
    connect = EventStore::HTTP::Session::Connect.new

    Controls::Settings::NonCluster::Unknown.set connect
    Controls::Session::ResolvDNS.configure connect

    test "Connection error is raised" do
      assert proc { connect.() } do
        raises_error? EventStore::HTTP::Session::Connect::ConnectionError
      end
    end
  end

  context "DNS resolver" do
    connect = EventStore::HTTP::Session::Connect.new

    Controls::Settings::NonCluster::Available.set connect
    Controls::Session::ResolvDNS.configure connect

    connection = connect.()

    test "Is closed after connecting" do
      assert connect.resolv_dns do
        @initialized == false
      end
    end
  end
end
