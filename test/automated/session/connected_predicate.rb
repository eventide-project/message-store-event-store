require_relative '../automated_init'

context "Session, Connected Predicate" do
  context "Session has not yet connected" do
    session = EventStore::HTTP::Session.new

    EventStore::HTTP::Session::NetHTTP.configure session

    test "False is returned" do
      assert session.connected? == false
    end
  end

  context "Session has connected" do
    session = EventStore::HTTP::Session.new

    EventStore::HTTP::Session::NetHTTP.configure session

    session.connect

    test "True is returned" do
      assert session.connected? == true
    end

    test "Net::HTTP session has started" do
      assert session.net_http do |net_http|
        net_http.started?
      end
    end
  end
end
