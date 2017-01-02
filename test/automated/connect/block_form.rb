require_relative '../automated_init'

context "Connecting To EventStore, Block Is Passed" do
  settings = Controls::Settings.example

  connect = EventSource::EventStore::HTTP::Connect.build settings

  context do
    connection = nil

    test "Active connection to EventStore is supplied to block" do
      connection = connect.() do |conn|
        assert conn do
          connected?
        end
      end
    end

    test "Connection is closed before returning" do
      assert connection do
        closed?
      end
    end
  end

  context "Exception is raised within block" do
    connection = nil

    begin
      connect.() do |conn|
        connection = conn
        fail
      end
    rescue RuntimeError
    end

    test "Connection is closed" do
      assert connection do
        closed?
      end
    end
  end
end
