require_relative '../automated_init'

context "Specifying Settings Namespace When Connecting to EventStore" do
  settings = Settings.build({
    :some_namespace => {
      :other_namespace => {
        :host => 'some-host',
        :port => 2222
      }
    }
  })

  connect = EventSource::EventStore::HTTP::Connect.build settings, namespace: [:some_namespace, :other_namespace]

  test "Host" do
    assert connect.host == 'some-host'
  end

  test "Port" do
    assert connect.port == 2222
  end
end
