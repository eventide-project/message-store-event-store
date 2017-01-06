require_relative '../automated_init'

context "Post Request" do
  post = EventSource::EventStore::HTTP::Request::Post.build

  path = Controls::URI::Path::Stream.example randomize_category: true

  request_body = Controls::EventData::Write::Text.example

  status_code = post.(path, request_body)

  test "Status code returned indicates POST was successful" do
    assert status_code == 201
  end
end
