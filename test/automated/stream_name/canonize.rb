require_relative '../automated_init'

context "Stream Name Canonization" do
  context do
    stream_name = Controls::StreamName.example

    test "Value is unchanged" do
      canonized_stream = EventSource::EventStore::HTTP::StreamName.canonize stream_name

      assert canonized_stream == stream_name
    end
  end

  context "Category stream" do
    stream_name = Controls::Category.example

    test "Category projection prefix is added ($ce-)" do
      canonized_stream = EventSource::EventStore::HTTP::StreamName.canonize stream_name

      assert canonized_stream == "$ce-#{stream_name}"
    end
  end
end
