module EventSource
  module EventStore
    module HTTP
      module ClusterStatus
        class Get
          module Transformer
            def self.json
              JSON
            end

            def self.instance(raw_data)
              record = Record.new

              raw_data[:members].each do |member_data|
                if member_data[:state] == Status.leader
                  record.leader_ip_address = member_data[:external_http_ip]
                end
              end

              record
            end

            module Status
              def self.leader
                'Master'
              end

              def self.follower
                'Slave'
              end
            end

            module JSON
              def self.read(text)
                formatted_data = ::JSON.parse text, symbolize_names: true

                raw_data = Casing::Underscore.(formatted_data)

                raw_data
              end
            end
          end
        end
      end
    end
  end
end
