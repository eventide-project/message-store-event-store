require_relative '../automated_init'

context "Iterator" do
  context "No further event data" do
    stream_name = Controls::Write.(instances: 2)

    iterator = MessageStore::EventStore::Read::Iterator.build(stream_name)
    MessageStore::EventStore::Get.configure(iterator, batch_size: 1)

    2.times { iterator.next }

    last = iterator.next

    test "Results in nil" do
      assert(last.nil?)
    end
  end
end
