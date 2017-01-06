require_relative '../automated_init'

context "Session Performs Request Whose Response Redirects To Leader" do
  leader_ip_address, follower_ip_address, * = Controls::ClusterMembers.get

  original_connection = EventStore::HTTP::Connect.(host: follower_ip_address)

  session = EventSource::EventStore::HTTP::Session.build
  session.connection = original_connection

  telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink session

  request = Controls::Session::Request::RequireLeader.example

  response = session.(request)

  test "Response is successful" do
    assert response.code == '201'
  end

  test "Session follows redirect" do
    assert telemetry_sink do
      recorded_redirected?
    end
  end

  test "Original connection is closed" do
    assert original_connection do
      closed?
    end
  end

  test "New connection is established with leader" do
    assert telemetry_sink do
      recorded_connection_established? do |record|
        record.data.host == leader_ip_address
      end
    end
  end
end
