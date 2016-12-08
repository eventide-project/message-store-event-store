require_relative './automated_init'

context "Session" do
  context "Connected predicate" do
    context "Session has not yet connected" do
      session = EventStore::HTTP::Session.new

      EventStore::HTTP::Settings.set session

      test "False is returned" do
        assert session.connected? == false
      end
    end

    context "Session has connected" do
      session = EventStore::HTTP::Session.new

      EventStore::HTTP::Settings.set session

      session.connect

      test "True is returned" do
        assert session.connected? == true
      end

      test "Net::HTTP session has started" do
        assert session.connection do |conn|
          conn.started?
        end
      end
    end
  end

  context "Session is built" do 
    session = EventStore::HTTP::Session.build

    test "HTTP session is started" do
      assert session.connected? == true
    end
  end
end
