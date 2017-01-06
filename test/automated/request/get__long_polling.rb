require_relative '../automated_init'

context "Get Request, Long Polling" do
  stream_name = Controls::Write.()

  path = Controls::URI::Path::Stream.example stream_name: stream_name

  context "Long polling is not enabled" do
    get = EventSource::EventStore::HTTP::Request::Get.build

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink get.session

    get.(path)

    test "Predicate returns false" do
      refute get.long_poll_enabled?
    end

    test "Request does not include ES-LongPoll header" do
      assert telemetry_sink do
        recorded_http_request? do |record|
          request = record.data.request

          request['ES-LongPoll'] == nil
        end
      end
    end
  end

  context "Long polling is enabled" do
    get = EventSource::EventStore::HTTP::Request::Get.build
    get.enable_long_poll

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink get.session

    get.(path)

    test "Predicate returns true" do
      assert get.long_poll_enabled?
    end

    test "Request includes ES-LongPoll header" do
      assert telemetry_sink do
        recorded_http_request? do |record|
          request = record.data.request

          request['ES-LongPoll'] == get.class::Defaults.long_poll_duration.to_s
        end
      end
    end
  end
end
