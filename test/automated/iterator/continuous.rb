require_relative '../automated_init'

context "Iterator, Continuous Cycle" do
  stream_name = Controls::Write.(2)

  get = EventSource::EventStore::HTTP::Get.build

  cycle = Cycle.build delay_milliseconds: 1111

  iterator = EventSource::Iterator.new get, stream_name
  iterator.cycle = cycle

  iterator.extend EventSource::EventStore::HTTP::Iterator

  context "Continuous predicate" do
    test "Is true" do
      assert iterator.continuous?
    end
  end

  context "Enabling long polling" do
    iterator.enable_long_poll

    test "Long poll duration on request is set to number of seconds, rounded up" do
      assert get.request.headers['ES-LongPoll'] == '2'
    end
  end
end
