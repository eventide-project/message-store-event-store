require_relative '../automated_init'

context "Post Request, Require Leader" do
  post = EventSource::EventStore::HTTP::Request::Post.build

  request_body = Controls::EventData::Write::Text.example

  context "Require leader is not enabled" do
    path = Controls::URI::Path::Stream.example randomize_category: true

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink post.session

    post.(path, request_body)

    test "Predicate returns false" do
      refute post.leader_required?
    end

    test "Request does not include ES-RequireMaster header" do
      assert telemetry_sink do
        recorded_http_request? do |record|
          request = record.data.request

          request['ES-RequireMaster'] == nil
        end
      end
    end
  end

  context "Require leader is enabled" do
    path = Controls::URI::Path::Stream.example randomize_category: true

    telemetry_sink = EventSource::EventStore::HTTP::Session.register_telemetry_sink post.session

    post.require_leader

    post.(path, request_body)

    test "Predicate returns true" do
      assert post.leader_required?
    end

    test "Request includes ES-ExpectedVersion header" do
      assert telemetry_sink do
        recorded_http_request? do |record|
          request = record.data.request

          request['ES-RequireMaster'] == 'True'
        end
      end
    end
  end
end
