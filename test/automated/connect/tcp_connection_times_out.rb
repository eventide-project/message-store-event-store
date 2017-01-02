require_relative '../automated_init'

context "Connecting To EventStore, TCP Connection Times Out" do
  ip_address = Controls::Settings::IPAddress.non_routable

  settings = Controls::Settings.example ip_address: ip_address, open_timeout: 0.1

  connect = EventSource::EventStore::HTTP::Connect.build settings

  test "Connection error is raised" do
    assert proc { connect.() } do
      raises_error? EventSource::EventStore::HTTP::Connect::ConnectionError
    end
  end
end
