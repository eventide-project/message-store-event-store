require_relative '../automated_init'

context "Session Issues Post Request" do
  session = EventSource::EventStore::HTTP::Session.build

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

  context "Recorded telemetry" do
    media_type = Controls::MediaType.events

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink session

    status_code = session.post path, request_body, media_type

    test "Path is recorded" do
      assert telemetry_sink do
        recorded_post? do |record|
          record.data.path == path
        end
      end
    end

    test "Status code is recorded" do
      assert telemetry_sink do
        recorded_post? do |record|
          record.data.status_code == 201
        end
      end
    end

    test "Reason phrase is recorded" do
      assert telemetry_sink do
        recorded_post? do |record|
          record.data.reason_phrase == 'Created'
        end
      end
    end

    test "Request body is recorded" do
      assert telemetry_sink do
        recorded_post? do |record|
          record.data.request_body == request_body
        end
      end
    end

    test "Content type is recorded" do
      assert telemetry_sink do
        recorded_post? do |record|
          record.data.content_type == media_type
        end
      end
    end
  end
end
