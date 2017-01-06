require_relative '../automated_init'

context "Get Request, Unknown Error" do
  get = EventSource::EventStore::HTTP::Request::Get.new

  get.session.set_response 500

  test "Error is raised" do
    assert proc { get.('/some/path') } do
      raises_error? EventSource::EventStore::HTTP::Request::Get::Error
    end
  end
end
