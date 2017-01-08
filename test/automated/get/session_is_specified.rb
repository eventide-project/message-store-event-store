require_relative '../automated_init'

context "Get, Session Is Specified" do
  session = EventSource::EventStore::HTTP::Session.build

  get = EventSource::EventStore::HTTP::Get.build session: session

  test "Specified session is set on request" do
    assert get.request.session.equal?(session)
  end
end
