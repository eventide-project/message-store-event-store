require_relative '../automated_init'

context "Iterator" do
  context "Next" do
    stream_name = Controls::Write.(instances: 2)

    iterator = MessageStore::EventStore::Read::Iterator.build(stream_name)
    MessageStore::EventStore::Get.configure(iterator, batch_size: 1)

    batch = []

    2.times do
      message_data = iterator.next
      batch << message_data unless message_data.nil?
    end

    test "Gets each message" do
      assert(batch.length == 2)
    end
  end
end
