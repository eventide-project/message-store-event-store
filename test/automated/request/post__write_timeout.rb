require_relative '../automated_init'

context "Post Request, Write Timeout" do
  post = EventSource::EventStore::HTTP::Request::Post.new

  post.session.set_response 500, reason_phrase: 'Write timeout'

  path = Controls::URI::Path::Stream.example randomize_category: true

  request_body = Controls::EventData::Write::Text.example

  test "Write timeout error is raised" do
    assert proc { post.(path, request_body) } do
      raises_error? EventSource::EventStore::HTTP::Request::Post::WriteTimeoutError
    end
  end
end
