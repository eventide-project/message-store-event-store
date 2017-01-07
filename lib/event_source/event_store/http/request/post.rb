module EventSource
  module EventStore
    module HTTP
      class Request
        class Post < Request
          include Log::Dependency

          def call(path, request_body, expected_version: nil, &probe)
            expected_version = EventSource::ExpectedVersion.canonize expected_version

            log_attributes = "Path: #{path}, ContentLength: #{request_body.bytesize}, MediaType: #{media_type}, Headers: #{headers.inspect}"
            logger.trace { "Performing POST request (#{log_attributes}" }

            request = Net::HTTP::Post.new path, headers
            request['Content-Type'] = media_type
            request['ES-ExpectedVersion'] = expected_version.to_s if expected_version
            request.body = request_body

            response = session.(request)

            probe.(request, response) if probe

            status_code = response.code.to_i

            log_attributes << ", StatusCode: #{status_code}, ReasonPhrase: #{response.message}"

            unless (200..299).include? status_code
              if expected_version_error? response
                error_message = "Wrong expected version number (#{log_attributes})"
                error_type = EventSource::ExpectedVersion::Error
              end

              if write_timeout_error? response
                error_message = "Write timeout (#{log_attributes})"
                error_type = WriteTimeoutError
              end

              error_message ||= "Post command failed (#{log_attributes})"
              error_type ||= Error

              logger.error error_message
              raise error_type, error_message
            end

            logger.debug { "POST request done (#{log_attributes}, StatusCode: #{status_code})" }

            return status_code
          end

          def require_leader
            headers['ES-RequireMaster'] = 'True'
          end

          def leader_required?
            headers.key? 'ES-RequireMaster'
          end

          def media_type
            MediaTypes.vnd_event_store_events_json
          end

          def expected_version_error?(response)
            response.code == '400' && response.message == 'Wrong expected EventNumber'
          end

          def write_timeout_error?(response)
            response.code == '500' && response.message == 'Write timeout'
          end

          Error = Class.new StandardError
          WriteTimeoutError = Class.new Error
        end
      end
    end
  end
end
