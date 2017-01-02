require_relative '../automated_init'

context "Connecting To EventStore, TCP Connection Is Refused" do
  ip_address = Controls::Settings::IPAddress.unavailable

  settings = Controls::Settings.example ip_address: ip_address

  connect = EventSource::EventStore::HTTP::Connect.build settings

  test "Connection error is raised" do
    assert proc { connect.() } do
      raises_error? EventSource::EventStore::HTTP::Connect::ConnectionError
    end
  end
end
