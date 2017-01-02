require_relative '../automated_init'

context "Get Cluster Status From Gossip Endpoint, HTTP Request Fails" do
  get = EventSource::EventStore::HTTP::ClusterStatus::Get.build
  get.uri_path = '/not-gossip'

  test "Request failure is raised" do
    assert proc { get.() } do
      raises_error? EventSource::EventStore::HTTP::ClusterStatus::Get::RequestFailure
    end
  end
end
