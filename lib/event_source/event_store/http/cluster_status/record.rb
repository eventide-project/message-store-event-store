module EventSource
  module EventStore
    module HTTP
      module ClusterStatus
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
