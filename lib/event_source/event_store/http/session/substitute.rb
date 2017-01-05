module EventSource
  module EventStore
    module HTTP
      class Session
        module Substitute
          def self.build
            Session.new
          end

          Response = Struct.new :code, :message, :body

          class Session
            attr_writer :status_code
            attr_writer :reason_phrase
            attr_accessor :response_body

            def call(request)
              response = Response.new
              response.code = status_code.to_s
              response.message = reason_phrase
              response.body = response_body.to_s
              response
            end

            def set_response(status_code, response_body=nil, reason_phrase: nil)
              self.status_code = status_code
              self.reason_phrase = reason_phrase
              self.response_body = response_body if response_body
            end

            def status_code
              @status_code ||= 404
            end

            def reason_phrase
              @reason_phrase ||= 'Not found'
            end
          end
        end
      end
    end
  end
end
