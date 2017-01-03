module EventSource
  module EventStore
    module HTTP
      module Clustering
        class GetLeader
          include Log::Dependency

          LOCALHOST = 'localhost'
          LOOPBACK_ADDRESS = '127.0.0.1'

          configure :get_leader

          dependency :connect, Connect
          dependency :get_status, GetStatus
          dependency :resolve_host, DNS::ResolveHost

          attr_accessor :host

          def self.build(connect=nil, host: nil)
            instance = new

            connect = Connect.configure instance, host: host if connect.nil?
            instance.host = connect.host

            GetStatus.configure instance, connect

            DNS::ResolveHost.configure instance

            instance
          end

          def self.call(*arguments)
            instance = build *arguments
            instance.()
          end

          def call
            logger.trace(tag: :get_leader) { "Getting cluster leader (Host: #{host.inspect})" }

            if host == LOCALHOST
              ip_addresses = [LOOPBACK_ADDRESS]
            else
              ip_addresses = resolve_host.(host)
            end

            if ip_addresses.count == 1
              ip_address = ip_addresses[0]

              logger.info(tag: :get_leader) { "DNS returned solitary address; presuming EventStore is not clustered (Host: #{host.inspect}, IPAddress: #{ip_address})" }

              return ip_address
            end

            ip_addresses.each do |ip_address|
              begin
                cluster_status = get_status.(ip_address)
              rescue Connect::ConnectionError, Clustering::GetStatus::RequestFailure => error
                logger.warn(tag: :get_leader) { "Could not determine cluster leader (Host: #{host.inspect}, IPAddress: #{ip_address}, Error: #{error.class})" }
                next
              end

              leader_ip_address = cluster_status.leader_ip_address

              logger.info(tag: :get_leader) { "Get leader done (Host: #{host.inspect}, LeaderIPAddress: #{leader_ip_address})" }

              return leader_ip_address
            end

            error_message = "Could not get leader (Host: #{host}, IPAddressList: [#{ip_addresses * ', '}])"
            logger.error(tag: :get_leader) { error_message }
            raise NoLeaderError, error_message
          end

          NoLeaderError = Class.new StandardError
        end
      end
    end
  end
end
