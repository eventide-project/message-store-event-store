module EventSource
  module EventStore
    module HTTP
      class Request
        class Post < Request
          include Log::Dependency

          def call(path, request_body, expected_version: nil, &probe)
            log_attributes = "Path: #{path}, ContentLength: #{request_body.bytesize}, MediaType: #{media_type}, Headers: #{headers.inspect}"

            logger.trace { "Performing GET request (#{log_attributes}" }

            request = Net::HTTP::Post.new path, headers

            request['Content-Type'] = media_type
            request['ES-ExpectedVersion'] = expected_version.to_s if expected_version

            request.body = request_body

            response = session.(request, &probe)

            status_code = response.code.to_i

            logger.debug { "GET request done (#{log_attributes}, StatusCode: #{status_code})" }

            return status_code
          end

          def require_leader
            headers['ES-RequireMaster'] = 'True'
          end

          def media_type
            MediaTypes.vnd_event_store_events_json
          end
        end
      end
    end
  end
end
