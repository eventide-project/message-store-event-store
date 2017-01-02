require_relative '../automated_init'

context "Get Cluster Status Build Method" do
  context "Connect dependency" do
    get_cluster_status = EventSource::EventStore::HTTP::ClusterStatus::Get.build

    test "Global settings are used" do
      global_settings = EventSource::EventStore::HTTP::Settings.instance

      connection = get_cluster_status.connect.()

      assert connection do
        connected?(
          host: global_settings.get(:host),
          port: global_settings.get(:port)
        )
      end
    end
  end
end
