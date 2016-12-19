require_relative '../automated_init'

context "Session Issues Get Request" do
  stream_name = Controls::Write.()

  session = EventStore::HTTP::Session.build

  path = Controls::URI::Path::Stream.example stream_name: stream_name

  context "EventStore can respond with requested media type" do
    media_type = Controls::MediaType.stream

    status_code, response_body = session.get path, media_type

    test "Status code returned indicates GET was successful" do
      assert status_code == 200
    end

    test "Response body is returned" do
      refute proc { JSON.parse response_body } do
        raises_error?
      end
    end
  end

  context "EventStore cannot respond with requested media type" do
    media_type = Controls::MediaType.unknown

    status_code, response_body = session.get path, media_type

    test "Status code returned indicates GET failed" do
      assert status_code == 406
    end

    test "No response body is returned" do
      assert response_body == nil
    end
  end
end
