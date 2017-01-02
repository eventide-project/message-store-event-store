require_relative '../automated_init'

context "Get Cluster Status From Gossip Endpoint On Non-Clustered EventStore" do
  get = EventSource::EventStore::HTTP::ClusterStatus::Get.build
  get.connect.read_timeout = Rational(100, 1000)

  test "Request failure is raised" do
    assert proc { get.() } do
      raises_error? EventSource::EventStore::HTTP::ClusterStatus::Get::RequestFailure
    end
  end
end
