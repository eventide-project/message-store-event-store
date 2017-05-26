require_relative '../automated_init'

context "Stream Name" do
  context "Get Types" do
    context "Many Types" do
      test "Types are the list of elements following a colon separator and preceding the ID" do
        stream_name = "someStream:someType+someOtherType"

        types = MessageStore::EventStore::StreamName.get_types(stream_name)

        assert(types == ['someType', 'someOtherType'])
      end
    end

    context "Single Type" do
      test "Types are the list of elements following a colon separator and preceding the ID" do
        stream_name = "someStream:someType"

        types = MessageStore::EventStore::StreamName.get_types(stream_name)

        assert(types == ['someType'])
      end
    end

    test "Is empty if there is no type list in the stream name" do
      types = MessageStore::EventStore::StreamName.get_types('someStream')
      assert(types.empty?)
    end

    context "Stream Name Contains Projection Prefix" do
      context "Many Types" do
        test "Types are the list of elements following a colon separator and preceding the ID" do
          stream_name = "$somePrefix-someStream:someType+someOtherType"

          types = MessageStore::EventStore::StreamName.get_types(stream_name)

          assert(types == ['someType', 'someOtherType'])
        end
      end

      context "Single Type" do
        test "Types are the list of elements following a colon separator and preceding the ID" do
          stream_name = "$somePrefix-someStream:someType"

          types = MessageStore::EventStore::StreamName.get_types(stream_name)

          assert(types == ['someType'])
        end
      end

      test "Is empty if there is no type list in the stream name" do
        types = MessageStore::EventStore::StreamName.get_types('$somePrefix-someStream')
        assert(types.empty?)
      end
    end
  end
end
