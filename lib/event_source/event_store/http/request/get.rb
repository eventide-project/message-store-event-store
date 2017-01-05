module EventSource
  module EventStore
    module HTTP
      class Request
        class Get < Request
          include Log::Dependency

          def call(path, &probe)
            log_attributes = "Path: #{path}, MediaType: #{media_type}, Headers: #{headers.inspect}"

            logger.trace { "Performing GET request (#{log_attributes}" }

            request = Net::HTTP::Get.new path, headers
            request['Accept'] = media_type

            response = session.(request, &probe)

            status_code = response.code.to_i
            response_body = response.body if (200..399).include? status_code

            logger.debug { "GET request done (#{log_attributes}, StatusCode: #{status_code})" }

            return status_code, response_body
          end

          def enable_long_poll
            headers['ES-LongPoll'] = Defaults.long_poll_duration.to_s
          end

          def media_type
            MediaTypes.vnd_event_store_atom_json
          end

          module Defaults
            def self.long_poll_duration
              duration = ENV['LONG_POLL_DURATION']

              return duration.to_i if duration

              15
            end
          end
        end
      end
    end
  end
end
