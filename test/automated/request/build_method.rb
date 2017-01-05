require_relative '../automated_init'

context "Request Build Method" do
  context "Session is not specified" do
    request = EventSource::EventStore::HTTP::Request.build

    test "Session is supplied" do
      assert request.session.instance_of?(EventSource::EventStore::HTTP::Session)
    end
  end

  context "Session is not specified" do
    session = EventSource::EventStore::HTTP::Session.build

    request = EventSource::EventStore::HTTP::Request.build session: session

    test "Specified session is used" do
      assert request.session.equal?(session)
    end
  end
end
