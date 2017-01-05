require_relative '../automated_init'

context "Post Request, Expected Version" do
  post = EventSource::EventStore::HTTP::Request::Post.build

  request_body = Controls::EventData::Write::Text.example

  context "Expected version is not set" do
    path = Controls::URI::Path::Stream.example randomize_category: true

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink post.session

    post.(path, request_body)

    test "Request does not include ES-ExpectedVersion header" do
      assert telemetry_sink do
        recorded_http_request? do |record|
          request = record.data.request

          request['ES-ExpectedVersion'] == nil
        end
      end
    end
  end

  context "Expected version is set" do
    expected_version = 11

    path = Controls::URI::Path::Stream.example randomize_category: true

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink post.session

    post.(path, request_body, expected_version: expected_version)

    test "Request includes ES-ExpectedVersion header" do
      assert telemetry_sink do
        recorded_http_request? do |record|
          request = record.data.request

          request['ES-ExpectedVersion'] == expected_version.to_s
        end
      end
    end
  end
end
