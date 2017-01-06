require_relative '../automated_init'

context "Post Request, Unknown Error" do
  post = EventSource::EventStore::HTTP::Request::Post.new

  post.session.set_response 500

  path = Controls::URI::Path::Stream.example randomize_category: true

  request_body = Controls::EventData::Write::Text.example

  test "Error is raised" do
    assert proc { post.(path, request_body) } do
      raises_error? EventSource::EventStore::HTTP::Request::Post::Error
    end
  end
end
