module EventSource
  module EventStore
    module HTTP
      class Session
        module Telemetry
          class Sink
            include ::Telemetry::Sink

            record :connection_established

            record :leader_status_queried

            record :http_request

            record :redirected

            def leader_status_query_successful?
              recorded_leader_status_queried? do |record|
                record.data.leader_status && record.data.error.nil?
              end
            end

            def leader_status_query_failed?
              recorded_leader_status_queried? do |record|
                record.data.leader_status.nil? && record.data.error
              end
            end
          end

          module RegisterSink
            def register_telemetry_sink(instance)
              sink = Telemetry::Sink.new

              instance.telemetry.register sink

              sink
            end
          end

          ConnectionEstablished = Struct.new :host, :port, :connection

          LeaderStatusQueried = Struct.new :leader_status, :error

          HTTPRequest = Struct.new(
            :action,
            :path,
            :status_code,
            :reason_phrase,
            :response_body,
            :acceptable_media_type,
            :request_body,
            :content_type
          )

          class HTTPRequest
            def self.build(request, response)
              instance = new(
                request.method,
                request.path,
                response.code.to_i,
                response.message,
                response.body,
                request['Accept']
              )

              if request.request_body_permitted?
                instance.request_body = request.body
                instance.content_type = request['Content-Type']
              end

              instance
            end
          end

          Redirected = Struct.new :requested_path, :origin_host, :redirect_uri
        end
      end
    end
  end
end
