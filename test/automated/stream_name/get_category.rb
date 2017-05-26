require_relative '../automated_init'

context "Stream Name" do
  context "Get Category" do
    category = 'someStream'

    context "Stream Name Contains an ID" do
      id = Identifier::UUID.random
      stream_name = "#{category}-#{id}"

      stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

      test "Category name is the part of the stream name before the first dash" do
        assert(stream_category == category)
      end
    end

    context "Stream Name Contains no ID" do
      stream_name = category
      stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

      test "Category name is the stream name" do
        assert(stream_category == category)
      end
    end

    context "Stream Name Contains Type" do
      stream_name = "#{category}:someType"
      stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

      test "Category name is the stream name" do
        assert(stream_category == stream_name)
      end
    end

    context "Stream Name Contains Types" do
      stream_name = "#{category}:someType+someOtherType"
      stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

      test "Category name is the stream name" do
        assert(stream_category == stream_name)
      end
    end

    context "Stream Name Contains ID and Types" do
      id = Identifier::UUID.random
      category_and_types = "#{category}:someType+someOtherType"
      stream_name = "#{category_and_types}-#{id}"

      stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

      test "Category name is the entity name and types" do
        assert(stream_category == category_and_types)
      end
    end

    context "Stream Name Contains Projection Prefix" do
      context "Stream Name Contains an ID" do
        id = Identifier::UUID.random
        stream_name = "$somePrefix-#{category}-#{id}"

        stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

        test "Category name is the part of the stream name before the first dash" do
          assert(stream_category == category)
        end
      end

      context "Stream Name Contains no ID" do
        stream_name = category
        stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

        test "Category name is the stream name" do
          assert(stream_category == category)
        end
      end

      context "Stream Name Contains Type" do
        category_and_type = "#{category}:someType"
        stream_name = "$somePrefix-#{category_and_type}"
        stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

        test "Category name is the stream name without the prefix" do
          assert(stream_category == category_and_type)
        end
      end

      context "Stream Name Contains Types" do
        category_and_types = "#{category}:someType+someOtherType"
        stream_name = "$somePrefix-#{category_and_types}"
        stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

        test "Category name is the stream name" do
          assert(stream_category == category_and_types)
        end
      end

      context "Stream Name Contains ID and Types" do
        id = Identifier::UUID.random
        category_and_types = "#{category}:someType+someOtherType"
        stream_name = "$somePrefix-#{category_and_types}-#{id}"

        stream_category = MessageStore::EventStore::StreamName.get_category(stream_name)

        test "Category name is the entity name and types" do
          assert(stream_category == category_and_types)
        end
      end
    end
  end
end
