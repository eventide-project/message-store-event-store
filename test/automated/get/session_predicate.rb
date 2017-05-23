require_relative '../automated_init'

context "Get" do
  context "Session predicate" do
    session = MessageStore::EventStore::Session.build

    get = MessageStore::EventStore::Get.build session: session

    context "Get session" do
      test "Is true" do
        assert get do
          session? session
        end
      end
    end

    context "Other session" do
      other_session = MessageStore::EventStore::Session.build

      test "Is false" do
        refute get do
          session? other_session
        end
      end
    end
  end
end
