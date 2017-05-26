require_relative '../automated_init'

context "Stream Name" do
  context "Is Category" do
    category = 'someStream'

    context "Stream Name Contains a Dash (-)" do
      id = Identifier::UUID.random
      stream_name = "#{category}-#{id}"

      is_category = MessageStore::EventStore::StreamName.category?(stream_name)

      test "Not a category" do
        refute(is_category)
      end
    end

    context "Stream Name Contains no Dash (-)" do
      is_category = MessageStore::EventStore::StreamName.category?(category)

      test "Is a category" do
        assert(is_category)
      end
    end

    context "Stream Name Contains Projection Prefix" do
      context "Stream Name Contains a Second Dash (-)" do
        id = Identifier::UUID.random
        stream_name = "$somePrefix-#{category}-#{id}"

        is_category = MessageStore::EventStore::StreamName.category?(stream_name)

        test "Not a category" do
          refute(is_category)
        end
      end

      context "Stream Name Contains no Second Dash (-)" do
        is_category = MessageStore::EventStore::StreamName.category?("$somePrefix-#{category}")

        test "Is a category" do
          assert(is_category)
        end
      end
    end
  end
end
