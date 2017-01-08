require_relative '../automated_init'

context "Put" do
  stream_name = Controls::StreamName.example
  write_event = Controls::EventData::Write.example

  position = EventSource::EventStore::HTTP::Put.(write_event, stream_name)

  get_response = Controls::Read::Event.(stream_name, position: position)

  test "Event is written" do
    assert get_response.code == '200'
  end

  context "Event stored in database" do
    event_store_data = JSON.parse(get_response.body)['content']

    test "Event ID" do
      assert Identifier::UUID::Pattern::TYPE_4.match?(event_store_data['eventId'])
    end

    test "Event type" do
      assert event_store_data['eventType'] == write_event.type
    end

    test "Data" do
      assert event_store_data['data'] == Casing::Camel.(write_event.data, symbol_to_string: true)
    end

    test "Metadata" do
      assert event_store_data['metadata'] == Casing::Camel.(write_event.metadata, symbol_to_string: true)
    end
  end
end
