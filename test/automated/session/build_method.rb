require_relative '../automated_init'

context "Session Is Built" do
  context do
    session = EventSource::EventStore::HTTP::Session.build

    test "Host is set" do
      assert session.host == Controls::Hostname.example
    end

    test "Port is set" do
      assert session.port == Controls::Port.example
    end

    context "Net::HTTP connection" do
      connection = session.connection

      test "Address is set to the IP address of the EventStore service" do
        assert connection.address == Controls::IPAddress.example
      end

      test "Port is set to that of port value in settings" do
        assert connection.port == Controls::Port.example
      end

      test "Session is not yet active" do
        assert connection.active?
      end
    end
  end

  context "Settings object is specified" do
    settings = Settings.build :host => 'example.com', :port => 80

    session = EventSource::EventStore::HTTP::Session.build settings

    test "Host is set" do
      assert session.host == 'example.com'
    end

    test "Port is set" do
      assert session.port == 80
    end
  end

  context "Settings namespace is specified" do
    settings = Settings.build :some_namespace => { :host => 'example.com', :port => 80 }

    session = EventSource::EventStore::HTTP::Session.build settings, namespace: :some_namespace

    test "Host is set" do
      assert session.host == 'example.com'
    end

    test "Port is set" do
      assert session.port == 80
    end
  end
end
