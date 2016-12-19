require_relative '../automated_init'

context "Session Is Built" do
  context do
    session = EventStore::HTTP::Session.build

    test "Net::HTTP session is started" do
      assert session.net_http do |net_http|
        net_http.started?
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
