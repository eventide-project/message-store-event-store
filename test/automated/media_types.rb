require_relative './automated_init'

context "EventStore Media Types" do
  test "Atompub JSON type (reading streams)" do
    media_type = EventSource::EventStore::HTTP::MediaTypes.vnd_event_store_atom_json

    assert media_type == Controls::MediaType.stream
  end

  test "Event type (writing events)" do
    media_type = EventSource::EventStore::HTTP::MediaTypes.vnd_event_store_events_json

    assert media_type == Controls::MediaType.events
  end
end
