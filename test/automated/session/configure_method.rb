require_relative '../automated_init'

context "Session Is Configured" do
  context do
    receiver = OpenStruct.new

    context "Attribute name is not specified" do
      EventStore::HTTP::Session.configure receiver

      test "Session attribute is set" do
        assert receiver.session.instance_of?(EventStore::HTTP::Session)
      end
    end

    context "Attribute name is specified" do
      EventStore::HTTP::Session.configure receiver, attr_name: :some_attr

      test "Specified attribute is set" do
        assert receiver.some_attr.instance_of?(EventStore::HTTP::Session)
      end
    end

    context "Namespace keyword argument is specified" do
      receiver = OpenStruct.new

      settings = Settings.build :some_namespace => { :host => 'example.com', :port => 80 }

      EventStore::HTTP::Session.configure(
        receiver,
        settings,
        namespace: :some_namespace,
        attr_name: :some_attr
      )

      test "Namespace is used when applying settings" do
        assert receiver.some_attr.host == 'example.com'
      end
    end
  end

  context "Session is specified" do
    session = Object.new

    context "Attribute name is not specified" do
      receiver = OpenStruct.new

      EventStore::HTTP::Session.configure receiver, session: session

      test "Session attribute is set to specified session" do
        assert receiver.session == session
      end
    end

    context "Attribute name is specified" do
      receiver = OpenStruct.new

      EventStore::HTTP::Session.configure receiver, session: session, attr_name: :some_attr

      test "Specified attribute is set to specified session" do
        assert receiver.some_attr == session
      end
    end
  end
end
