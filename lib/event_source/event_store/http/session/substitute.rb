module EventSource
  module EventStore
    module HTTP
      class Session
        module Substitute
          def self.build
            Session.build
          end

          class Session < Session
            attr_accessor :telemetry_sink

            def self.build
              instance = new

              ::Telemetry.configure instance

              instance.telemetry_sink = register_telemetry_sink instance

              instance
            end

            def set_response(status_code, response_body=nil)
              net_http.set_response status_code, response_body
            end

            module Assertions
              def get_request?(&block)
                block ||= proc { true }

                telemetry_sink.recorded_get? do |record|
                  block.(record.data)
                end
              end

              def post_request?(&block)
                block ||= proc { true }

                telemetry_sink.recorded_post? do |record|
                  block.(record.data)
                end
              end
            end
          end
        end
      end
    end
  end
end
