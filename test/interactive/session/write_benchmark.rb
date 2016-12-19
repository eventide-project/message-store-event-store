require_relative '../interactive_init'

writes = 0

set_expected_version = ENV['EXPECTED_VERSION'] == 'on'
stream_count = ENV['STREAM_COUNT'].to_i
stream_count = 1 if stream_count.zero?

session = EventSource::EventStore::HTTP::Session.build

comment "Expected version: #{set_expected_version ? 'on' : 'off'}"
comment "Host: #{session.host}"
comment "Port: #{session.port}"
comment "Streams receiving writes: #{stream_count}"
comment ' '
comment "Press CTRL+C to stop"

paths = (0...stream_count).map do
  stream_name = Controls::StreamName.example randomize_category: false

  "/streams/#{stream_name}"
end

begin
  start_time = Clock.now
  version = -1

  loop do
    paths.each do |path|
      event_id = Identifier::UUID::Random.get

      request_body = <<~JSON % [event_id, writes]
      [
        {
          "eventId": "%s",
          "eventType": "SomeEvent",
          "data": { "index": %i }
        }
      ]
      JSON

      headers = {}

      if set_expected_version
        headers['ES-ExpectedVersion'] = version.to_s
      end

      session.post(
        path,
        request_body,
        EventSource::EventStore::MediaTypes.vnd_event_store_events_json,
        headers
      ) do |response|
        unless response.code == '201'
          fail "Write failed (StatusCode: #{response.code}, ReasonPhrase: #{response.message})"
        end
      end

      writes += 1
    end

    version += 1
  end

rescue Interrupt
  elapsed_time = Clock.now - start_time

  report_operations_per_second writes, elapsed_time
end
