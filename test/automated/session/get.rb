require_relative '../automated_init'

context "Session Issues Get Request" do
  stream_name = Controls::Write.()

  path = Controls::URI::Path::Stream.example stream_name: stream_name

  session = EventStore::HTTP::Session.build

  context "HTTP request is successful" do
    media_type = Controls::MediaType.stream

    status_code, response_body = session.get path, media_type

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

    status_code, response_body = session.get path, media_type

    test "Status code returned indicates GET failed" do
      assert status_code == 406
    end

    test "No response body is returned" do
      assert response_body == nil
    end
  end

  context "Recorded telemetry" do
    media_type = Controls::MediaType.stream

    telemetry_sink = EventStore::HTTP::Session.register_telemetry_sink session

    status_code, response_body = session.get path, media_type

    test "Path is recorded" do
      assert telemetry_sink do
        recorded_get? do |record|
          record.data.path == path
        end
      end
    end

    test "Status code is recorded" do
      assert telemetry_sink do
        recorded_get? do |record|
          record.data.status_code == 200
        end
      end
    end

    test "Reason phrase is recorded" do
      assert telemetry_sink do
        recorded_get? do |record|
          record.data.reason_phrase == 'OK'
        end
      end
    end

    test "Response body is recorded" do
      assert telemetry_sink do
        recorded_get? do |record|
          record.data.response_body == response_body
        end
      end
    end

    test "Acceptable media type is recorded" do
      assert telemetry_sink do
        recorded_get? do |record|
          record.data.acceptable_media_type == media_type
        end
      end
    end
  end
end
