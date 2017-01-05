module EventSource
  module EventStore
    module HTTP
      class Session
        module LogText
          def self.establishing_connection(session, leader_ip_address)
            "HostSetting: #{session.host}, PortSetting: #{session.port}, LeaderIPAddress: #{leader_ip_address || '(unknown)'}"
          end

          def self.connection_established(session, leader_ip_address)
            "HostSetting: #{session.host}, PortSetting: #{session.port}, LeaderIPAddress: #{leader_ip_address || '(unused)'}"
          end

          def self.request_attributes(request)
            "Path: #{request.path}, Host: #{request['Host'] || '(not yet set)'}, MediaType: #{request['Content-Type'] || '(none)'}, ContentLength: #{request.body&.bytesize.to_i}, Accept: #{request['Accept'] || '(none)'}"
          end

          def self.request_body(request)
            if request.body.nil? || request.body.empty?
              "Request: (none)'"
            else
              "Request:\n\n#{request.body}"
            end
          end

          def self.response_attributes(response)
            "StatusCode: #{response.code}, ReasonPhrase: #{response.message}"
          end

          def self.response_body(response)
            if response.body.empty?
              "Response: (none)"
            else
              "Response:\n\n#{response.body}"
            end
          end
        end
      end
    end
  end
end
