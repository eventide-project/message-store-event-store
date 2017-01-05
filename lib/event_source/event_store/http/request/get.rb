module EventSource
  module EventStore
    module HTTP
      class Request
        class Get < Request
          include Log::Dependency

          def call(path, media_type, headers=nil, &probe)
            log_attributes = "Path: #{path}, MediaType: #{media_type}, Headers: #{headers.inspect}"

            logger.trace { "Performing GET request (#{log_attributes}" }

            headers ||= {}
            headers['Accept'] = media_type

            request = Net::HTTP::Get.new path, headers

            response = session.(request, &probe)

            status_code = response.code.to_i
            response_body = response.body if (200..399).include? status_code

            logger.debug { "GET request done (#{log_attributes}, StatusCode: #{status_code})" }

            return status_code, response_body
          end
        end
      end
    end
  end
end
