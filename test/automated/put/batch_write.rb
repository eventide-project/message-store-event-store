require_relative '../automated_init'

context "Put, Batch Of Events Is Written" do
  stream_name = Controls::StreamName.example

  batch = [
    Controls::EventData::Write.example,
    Controls::EventData::Write.example
  ]

  position = EventSource::EventStore::HTTP::Put.(batch, stream_name)

  get_response = EventStore::HTTP::Connect.() do |http|
    http.request_get(
      "/streams/#{stream_name}/#{position}/forward/2?embed=body",
      { 'Accept' => EventSource::EventStore::HTTP::MediaTypes.vnd_event_store_atom_json }
    )
  end

  test "Batch is written" do
    assert get_response.code == '200'
  end

  events = JSON.parse(get_response.body)['entries'].reverse

  events.each_with_index do |event_store_data, index|
    write_event = batch.fetch index

    context "Event ##{index + 1}" do
      test "Event ID" do
        assert Identifier::UUID::Pattern::TYPE_4.match?(event_store_data['eventId'])
      end

      test "Event type" do
        assert event_store_data['eventType'] == write_event.type
      end

      test "Data" do
        data = JSON.parse event_store_data['data']

        assert data == Casing::Camel.(write_event.data, symbol_to_string: true)
      end

      test "Metadata" do
        metadata = JSON.parse event_store_data['metaData']

        assert metadata == Casing::Camel.(write_event.metadata, symbol_to_string: true)
      end
    end
  end
end
