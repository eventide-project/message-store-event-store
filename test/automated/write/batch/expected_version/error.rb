require_relative '../../../automated_init'

context "Write" do
  context "Batch" do
    context "Expected Version" do
      context "Does not match the stream version" do
        stream_name = Controls::StreamName.example

        write_message = Controls::MessageData::Write.example
        position = MessageStore::EventStore::Write.(write_message, stream_name)

        incorrect_stream_version = position  + 1

        write_message_1 = Controls::MessageData::Write.example
        write_message_2 = Controls::MessageData::Write.example

        batch = [write_message_1, write_message_2]

        erroneous = proc {
          MessageStore::EventStore::Write.(
            batch,
            stream_name,
            expected_version: incorrect_stream_version
          )
        }

        test "Is an error" do
          assert erroneous do
            raises_error? MessageStore::ExpectedVersion::Error
          end
        end

        context "Messages" do
          2.times do |i|
            read_message, * = MessageStore::EventStore::Get.(stream_name, position: i + 1, batch_size: 1)

            test "Message #{i + 1} not written" do
              assert(read_message.nil?)
            end
          end
        end
      end
    end
  end
end
