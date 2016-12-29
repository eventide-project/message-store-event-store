require_relative '../../automated_init'

context "Session Connects To Non-Clustered EventStore By IP Address" do
  context "EventStore is available" do
    connect = EventStore::HTTP::Session::Connect.new
    Controls::Settings::NonCluster::Available.set connect, ip_address: true

    connection = connect.()

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

  context "EventStore is unavailable, connection refused" do
    connect = EventStore::HTTP::Session::Connect.new

    Controls::Settings::NonCluster::Unavailable.set connect, ip_address: true

    test "Connection error is raised" do
      assert proc { connect.() } do
        raises_error? EventStore::HTTP::Session::Connect::ConnectionError
      end
    end
  end

  context "EventStore is unavailable, address is not available" do
    connect = EventStore::HTTP::Session::Connect.new

    ip_address = Controls::Settings::NonCluster::Unavailable::IPAddress::NotAvailable.example
    Controls::Settings::NonCluster::Unavailable.set connect, ip_address: ip_address

    test "Connection error is raised" do
      assert proc { connect.() } do
        raises_error? EventStore::HTTP::Session::Connect::ConnectionError
      end
    end
  end
end
