require_relative '../automated_init'

context "Session Closes Connection" do
  session = EventSource::EventStore::HTTP::Session.build

  connection = session.connection

  session.close

  test "HTTP connection is terminated" do
    refute connection.active?
  end

  test "New connection is established" do
    next_connection = session.connection

    assert next_connection.active?
  end
end
