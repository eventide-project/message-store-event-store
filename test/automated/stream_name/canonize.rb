require_relative '../automated_init'

context "Stream Name Canonization" do
  context "Stream" do
    context do
      stream = Controls::Stream.example

      test "Value is unchanged" do
        canonized_stream = EventSource::EventStore::HTTP::StreamName.canonize stream

        assert canonized_stream == stream.name
      end
    end

    context "Category stream" do
      stream = Controls::Stream::Category.example

      test "Category projection prefix is added ($ce-)" do
        canonized_stream = EventSource::EventStore::HTTP::StreamName.canonize stream

        assert canonized_stream == "$ce-#{stream.name}"
      end
    end
  end

  context "Stream name" do
    context do
      stream_name = Controls::StreamName.example

      test "Value is unchanged" do
        canonized_stream = EventSource::EventStore::HTTP::StreamName.canonize stream_name

        assert canonized_stream == stream_name
      end
    end

    context "Category stream" do
      stream_name = Controls::StreamName::Category.example

      test "Category projection prefix is added ($ce-)" do
        canonized_stream = EventSource::EventStore::HTTP::StreamName.canonize stream_name

        assert canonized_stream == "$ce-#{stream_name}"
      end
    end
  end
end
