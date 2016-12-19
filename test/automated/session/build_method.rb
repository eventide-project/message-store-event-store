require_relative '../automated_init'

context "Session Is Built" do
  session = EventStore::HTTP::Session.build

  test "Net::HTTP session is started" do
    assert session.net_http do |net_http|
      net_http.started?
    end
  end
end
