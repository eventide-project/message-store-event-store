require_relative '../automated_init'

context "Session Closes Connection" do
  session = EventStore::HTTP::Session.build

  previous_connection = session.close

  test "Net::HTTP connection is terminated" do
    refute previous_connection.started?
  end
end
