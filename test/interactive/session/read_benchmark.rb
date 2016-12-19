require_relative '../interactive_init'

reads = 0

batch_size = (ENV['BATCH_SIZE'] || '25').to_i
batch_count = (ENV['BATCH_COUNT'] || '1').to_i

stream_name = Controls::StreamName.example

batch_count.times do
  Controls::Write.(batch_size, stream_name: stream_name)
end

session = EventSource::EventStore::HTTP::Session.build

comment "Batch size: #{batch_size}"
comment "Batch count: #{batch_count}"
comment "Host: #{session.host}"
comment "Port: #{session.port}"
comment "Stream: #{stream_name}"
comment ' '
comment "Press CTRL+C to stop"

begin
  start_time = Clock.now
  version = -1

  loop do
    batch_count.times do |batch_index|
      start_position = batch_index * batch_size

      _, response_body = session.get(
        "/streams/#{stream_name}/#{start_position}/forward/#{batch_size}?embed=body",
        EventSource::EventStore::MediaTypes.vnd_event_store_atom_json
      ) do |response|
        unless response.code == '200'
          fail "Read failed (StatusCode: #{response.code}, ReasonPhrase: #{response.message})"
        end
      end

      reads += batch_size
    end
  end

rescue Interrupt
  elapsed_time = Clock.now - start_time

  report_operations_per_second reads, elapsed_time
end
