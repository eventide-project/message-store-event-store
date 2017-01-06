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
    expected_version = EventSource::NoStream.version

    path = Controls::URI::Path::Stream.example randomize_category: true

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink post.session

    status_code = post.(path, request_body, expected_version: expected_version)

    test "Request is successful" do
      assert (200..299).include?(status_code)
    end

    test "Request includes ES-ExpectedVersion header" do
      assert telemetry_sink do
        recorded_http_request? do |record|
          request = record.data.request

          request['ES-ExpectedVersion'] == expected_version.to_s
        end
      end
    end
  end

  context "Expected version is set to :no_stream" do
    expected_version = EventSource::NoStream.name

    path = Controls::URI::Path::Stream.example randomize_category: true

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink post.session

    post.(path, request_body, expected_version: expected_version)

    test "ES-ExpectedVersion header is set to -1" do
      assert telemetry_sink do
        recorded_http_request? do |record|
          request = record.data.request

          request['ES-ExpectedVersion'] == Controls::ExpectedVersion::NoStream::Header.example
        end
      end
    end
  end

  context "Expected version does not match database" do
    expected_version = Controls::ExpectedVersion.example

    path = Controls::URI::Path::Stream.example randomize_category: true

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink post.session

    test "Expected version error is raised" do
      assert proc { post.(path, request_body, expected_version: expected_version) } do
        raises_error? EventSource::EventStore::HTTP::Request::Post::ExpectedVersionError
      end
    end

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