require_relative '../../automated_init'

context "Get Leader Build Method" do
  context "Connect dependency" do
    get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build

    test "Global settings are used" do
      global_settings = EventSource::EventStore::HTTP::Settings.instance

      connection = get_leader.connect.()

      assert connection do
        connected?(
          host: global_settings.get(:host),
          port: global_settings.get(:port)
        )
      end
    end
  end

  context "Host" do
    host = 'some-host'

    settings = Controls::Settings.example host: host
    connect = EventSource::EventStore::HTTP::Connect.build settings

    get_leader = EventSource::EventStore::HTTP::Clustering::GetLeader.build connect

    test "Value is set to that of connect dependency" do
      assert get_leader.host == host
    end
  end
end
