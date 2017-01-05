require_relative '../automated_init'

context "Get Request" do
  stream_name = Controls::Write.()

  path = Controls::URI::Path::Stream.example stream_name: stream_name

  request = EventSource::EventStore::HTTP::Request::Get.build

  context "HTTP request is successful" do
    media_type = Controls::MediaType.stream

    status_code, response_body = request.(path, media_type)

    test "Status code returned indicates GET was successful" do
      assert status_code == 200
    end

    test "Response body is returned as valid JSON" do
      refute proc { JSON.parse response_body } do
        raises_error?
      end
    end
  end

  context "HTTP request is unsuccessful" do
    media_type = Controls::MediaType.unknown

    status_code, response_body = request.(path, media_type)

    test "Status code returned indicates GET failed" do
      assert status_code == 406
    end

    test "No response body is returned" do
      assert response_body == nil
    end
  end
end
