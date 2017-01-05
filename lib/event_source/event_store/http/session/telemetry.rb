module EventSource
  module EventStore
    module HTTP
      class Session
        module Telemetry
          class Sink
            include ::Telemetry::Sink

            record :connection_established

            record :leader_status_queried

            record :get
            record :post

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

          ConnectionEstablished = Struct.new :host, :port, :connection

          LeaderStatusQueried = Struct.new :leader_status, :error

          Get = Struct.new(
            :path,
            :status_code,
            :reason_phrase,
            :response_body,
            :acceptable_media_type
          )

          Post = Struct.new(
            :path,
            :status_code,
            :reason_phrase,
            :request_body,
            :content_type
          )
        end
      end
    end
  end
end
