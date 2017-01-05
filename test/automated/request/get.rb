require_relative '../automated_init'

context "Get Request" do
  get = EventSource::EventStore::HTTP::Request::Get.build

  stream_name = Controls::Write.()

  path = Controls::URI::Path::Stream.example stream_name: stream_name

  context "HTTP request is successful" do
    response_body, status_code = get.(path)

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
    response_body, status_code = get.('/not-a-path')

    test "Status code returned indicates GET failed" do
      assert status_code == 404
    end

    test "No response body is returned" do
      assert response_body == nil
    end
  end
end
