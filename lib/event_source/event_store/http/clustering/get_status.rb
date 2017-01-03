module EventSource
  module EventStore
    module HTTP
      module Clustering
        class GetStatus
          include Log::Dependency

          configure :get_status

          dependency :connect, Connect

          attr_writer :uri_path

          def self.build(connect=nil)
            instance = new

            if connect.nil?
              Connect.configure instance
            else
              instance.connect = connect
            end

            instance
          end

          def call(host=nil)
            log_attributes = self.log_attributes host

            logger.trace { "Getting cluster status (#{log_attributes})" }

            connect.(host) do |connection|
              begin
                response = connection.request_get uri_path, http_headers
              rescue Net::ReadTimeout => error
                error_message = "Specified EventStore is not member of cluster (#{log_attributes}, Error: #{error.class})"
                logger.error error_message
                raise RequestFailure, error_message
              end

              log_attributes << ", StatusCode: #{response.code}, ReasonPhrase: #{response.message}"

              unless response.code == '200'
                error_message = "Get cluster status failed (#{log_attributes})"
                logger.error error_message
                raise RequestFailure, error_message
              end

              cluster_status = Transform::Read.(response.body, :json, self.class)

              logger.debug { "Get cluster status done (#{log_attributes}, ClusterStatus: #{cluster_status.digest})" }

              return cluster_status
            end
          end

          def log_attributes(host=nil)
            host ||= connect.host

            "Host: #{host}, Port: #{connect.port}, URIPath: #{uri_path}"
          end

          def uri_path
            @uri_path ||= '/gossip'
          end

          def http_headers
            { 'Accept' => 'application/json' }
          end

          RequestFailure = Class.new StandardError
        end
      end
    end
  end
end
