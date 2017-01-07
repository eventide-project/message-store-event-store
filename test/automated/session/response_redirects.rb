require_relative '../automated_init'

context "Session Performs Request Whose Response Redirects" do
  leader_ip_address, follower_ip_address, * = Controls::ClusterMembers.get

  original_connection = EventStore::HTTP::Connect.(host: follower_ip_address)

  session = EventSource::EventStore::HTTP::Session.build
  session.connection = original_connection

  telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink session

  request = Controls::Session::Request::Redirects.example

  response = session.(request)

  test "Response is successful" do
    assert response.code == '201'
  end

  test "Session follows redirect" do
    assert telemetry_sink do
      recorded_redirected?
    end
  end

  test "Original connection is not closed" do
    refute original_connection do
      closed?
    end
  end

  test "No new connection is established" do
    refute telemetry_sink do
      recorded_connection_established?
    end
  end
end
