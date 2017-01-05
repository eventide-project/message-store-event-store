module EventSource
  module EventStore
    module HTTP
      class Session
        module Telemetry
          class Sink
            include ::Telemetry::Sink

            record :leader_status_queried

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

          LeaderStatusQueried = Struct.new :leader_status, :error
        end
      end
    end
  end
end
