require_relative '../automated_init'

context "Session Is Built" do
  context do
    session = EventStore::HTTP::Session.build

    context "Net::HTTP session" do
      net_http = session.net_http

      test "Address is set to that of host value in settings" do
        assert net_http.address == EventStore::HTTP::Settings.get(:host)
      end

      test "Port is set to that of port value in settings" do
        assert net_http.port == EventStore::HTTP::Settings.get(:port)
      end

      test "Read timeout is set to that of read timeout value in settings" do
        assert net_http.read_timeout == EventStore::HTTP::Settings.get(:read_timeout)
      end

      test "Session is started" do
        assert session.net_http do |net_http|
          net_http.started?
        end
      end
    end
  end

  context "Settings object is specified" do
    settings = Settings.build :host => 'example.com', :port => 80

    session = EventStore::HTTP::Session.build settings

    test "Host is set" do
      assert session.host == 'example.com'
    end

    test "Port is set" do
      assert session.port == 80
    end
  end

  context "Settings namespace is specified" do
    settings = Settings.build :some_namespace => { :host => 'example.com', :port => 80 }

    session = EventStore::HTTP::Session.build settings, namespace: :some_namespace

    test "Host is set" do
      assert session.host == 'example.com'
    end

    test "Port is set" do
      assert session.port == 80
    end
  end
end
