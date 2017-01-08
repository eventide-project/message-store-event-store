require_relative '../automated_init'

context "Iterator, Timeout Is Set On Cycle" do
  stream_name = Controls::Write.(2)

  get = EventSource::EventStore::HTTP::Get.build

  cycle = Cycle.build timeout_milliseconds: 1

  iterator = EventSource::Iterator.new get, stream_name
  iterator.cycle = cycle

  iterator.extend EventSource::EventStore::HTTP::Iterator

  context "Continuous predicate" do
    test "Is false" do
      refute iterator.continuous?
    end
  end
end
