module EventSource
  module EventStore
    module HTTP
      module Clustering
        class GetStatus
          class Record
            include Schema::DataStructure

            attribute :leader_ip_address, String

            def digest
              "[LeaderIPAddress: #{leader_ip_address}]"
            end
          end
        end
      end
    end
  end
end
