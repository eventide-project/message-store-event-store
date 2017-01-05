module EventSource
  module EventStore
    module HTTP
      class Request
        class Post < Request
          include Log::Dependency

          def call(path, media_type, request_body, &probe)
            log_attributes = "Path: #{path}, ContentLength: #{request_body.bytesize}, MediaType: #{media_type}, Headers: #{headers.inspect}"

            logger.trace { "Performing GET request (#{log_attributes}" }

            request = Net::HTTP::Post.new path
            request['Content-Type'] = media_type
            request.body = request_body

            response = session.(request, &probe)

            status_code = response.code.to_i

            logger.debug { "GET request done (#{log_attributes}, StatusCode: #{status_code})" }

            return status_code
          end
        end
      end
    end
  end
end
