require_relative '../automated_init'

context "Session Connects To Non-Clustered EventStore By IP Address" do
  context "EventStore is available" do
    connect = EventStore::HTTP::Session::Connect.new

    Controls::Settings.set connect, ip_address: true

    connection = connect.()

    test "Net::HTTP connection is returned" do
      assert connection.instance_of?(Net::HTTP)
    end

    test "IP address specified in settings is used" do
      assert connection.address == Controls::Settings.ip_address
    end

    test "Port specified in settings is used" do
      assert connection.port == Controls::Settings.port
    end
  end

  context "EventStore is unavailable, connection refused" do
    ip_address = Controls::Settings::EventStoreUnavailable.ip_address

    connect = EventStore::HTTP::Session::Connect.new

    Controls::Settings.set connect, ip_address: ip_address

    test "Connection error is raised" do
      assert proc { connect.() } do
        raises_error? EventStore::HTTP::Session::Connect::ConnectionError
      end
    end
  end

  context "EventStore is unavailable, address is not available" do
    ip_address = '127.0.0.3'

    connect = EventStore::HTTP::Session::Connect.new

    Controls::Settings.set connect, ip_address: ip_address

    test "Connection error is raised" do
      assert proc { connect.() } do
        raises_error? EventStore::HTTP::Session::Connect::ConnectionError
      end
    end
  end
end
