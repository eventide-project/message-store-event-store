require_relative '../automated_init'

context "Session Issues Post Request" do
  session = EventStore::HTTP::Session.build

  path = Controls::URI::Path::Stream.example randomize_category: true

  request_body = Controls::EventData::Write::Text.example

  context "Request is acceptable to EventStore" do
    media_type = Controls::MediaType.events

    status_code = session.post path, request_body, media_type

    test "Status code returned indicates POST was successful" do
      assert status_code == 201
    end
  end

  context "Media type is unknown to EventStore" do
    media_type = Controls::MediaType.unknown

    status_code = session.post path, request_body, media_type

    test "Status code returned indicates POST was not accepted" do
      assert status_code == 400
    end
  end
end
