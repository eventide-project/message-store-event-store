require_relative '../automated_init'

context "Get" do
  context "Category" do
    category = Controls::Category.example

    Controls::Write.(1, category: category)
    Controls::Write.(2, category: category)

    category_stream_name = EventSource::EventStore::HTTP::StreamName.category_stream_name category

    events = EventSource::EventStore::HTTP::Get.(category_stream_name)

    number_of_events = events.count

    test "Number of events retrieved is the number written to the category" do
      assert number_of_events == 3
    end
  end
end
