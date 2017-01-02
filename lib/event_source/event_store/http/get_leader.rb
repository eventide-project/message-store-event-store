module EventSource
  module EventStore
    module HTTP
      class GetLeader
        include Log::Dependency

        dependency :connect, Connect
        dependency :get_cluster_status, ClusterStatus::Get
        dependency :resolve_host, DNS::ResolveHost

        attr_accessor :host

        def self.build(connect=nil)
          instance = new

          connect = Connect.configure instance if connect.nil?
          instance.host = connect.host

          ClusterStatus::Get.configure instance, connect

          DNS::ResolveHost.configure instance

          instance
        end

        def self.call(*arguments)
          instance = build *arguments
          instance.()
        end

        def call
          logger.trace(tag: :get_leader) { "Getting leader (Host: #{host.inspect})" }

          ip_addresses = resolve_host.(host)

          if ip_addresses.count == 1
            ip_address = ip_addresses[0]

            logger.info(tag: :get_leader) { "EventStore is not clustered; returning IP address (Host: #{host.inspect}, IPAddress: #{ip_address})" }

            return ip_address
          end

          ip_addresses.each do |ip_address|
            begin
              cluster_status = get_cluster_status.(ip_address)
            rescue Connect::ConnectionError, ClusterStatus::Get::RequestFailure => error
              logger.warn(tag: :get_leader) { "Could not determine leader (Host: #{host.inspect}, IPAddress: #{ip_address}, Error: #{error.class})" }
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
