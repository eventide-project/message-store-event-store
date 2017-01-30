require_relative '../automated_init'

context "Put" do
  context "No session specified" do
    put = EventSource::EventStore::HTTP::Put.build

    context "Write connection" do
      write_connection = put.write.connection

      test "Is session" do
        assert write_connection.is_a?(EventSource::EventStore::HTTP::Session)
      end
    end
  end

  context "No session specified" do
    session = EventSource::EventStore::HTTP::Session.build

    put = EventSource::EventStore::HTTP::Put.build session: session

    context "Write connection" do
      write_connection = put.write.connection

      test "Is specifed session" do
        assert write_connection.equal?(session)
      end
    end
  end
end
