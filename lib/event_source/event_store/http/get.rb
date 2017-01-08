module EventSource
  module EventStore
    module HTTP
      class Get
        include Log::Dependency

        configure :get

        initializer :slice_size, :direction

        dependency :request, Request::Get

        def self.build(batch_size: nil, precedence: nil, session: nil)
          batch_size ||= Defaults.batch_size
          direction = self.direction precedence

          instance = new batch_size, direction
          Request::Get.configure instance, session: session
          instance
        end

        def self.call(stream_name, position: nil, batch_size: nil, precedence: nil, session: nil)
          instance = build batch_size: batch_size, precedence: precedence, session: session
          instance.(stream_name, position: position)
        end

        def call(stream_name, position: nil)
          position ||= 0

          path = stream_path stream_name, position

          json_text, status_code = request.(path)

          response = JSON.parse json_text

          response['entries'].map do |entry_data|
            event_data = EventData::Read.build(
              :type => entry_data['eventType'],
              :stream_name => entry_data['streamId'],
              :position => entry_data['eventNumber'],
              :global_position => entry_data['positionEventNumber']
            )

            data = JSON.parse entry_data['data'], symbolize_names: true
            data = Casing::Underscore.(data)

            event_data.data = data

            metadata = JSON.parse entry_data['metaData'], symbolize_names: true
            metadata = Casing::Underscore.(metadata)

            event_data.metadata = metadata

            event_data
          end
        end

        def stream_path(stream_name, position)
          "/streams/#{stream_name}/#{position}/#{direction}/#{slice_size}?embed=body"
        end

        def self.direction(precedence=nil)
          precedence ||= Defaults.precedence

          {
            :asc => 'forward',
            :desc => 'backward'
          }.fetch precedence
        end

        module Defaults
          def self.batch_size
            batch_size = ENV['EVENT_STORE_SLICE_SIZE']

            return batch_size.to_i if batch_size

            20
          end

          def self.precedence
            :asc
          end
        end
      end
    end
  end
end
