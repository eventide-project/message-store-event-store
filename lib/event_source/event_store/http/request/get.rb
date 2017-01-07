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

            response = session.(request)

            probe.(request, response) if probe

            log_attributes << ", StatusCode: #{response.code}, ReasonPhrose: #{response.message}"

            status_code = response.code.to_i

            if (200..399).include? status_code
              response_body = response.body
            elsif status_code == 404
              logger.warn "Get query failed, resource not found (#{log_attributes})"
            else
              error_message = "Get command failed (#{log_attributes})"
              logger.error error_message
              raise Error, error_message
            end

            logger.debug { "GET request done (#{log_attributes}, StatusCode: #{status_code})" }

            return response_body, status_code
          end

          def enable_long_poll
            headers['ES-LongPoll'] = Defaults.long_poll_duration.to_s
          end

          def long_poll_enabled?
            headers.key? 'ES-LongPoll'
          end

          def media_type
            MediaTypes.vnd_event_store_atom_json
          end

          Error = Class.new StandardError

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
