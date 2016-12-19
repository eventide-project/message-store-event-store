module EventSource
  module EventStore
    module HTTP
      class Session
        module NetHTTP
          def self.configure(receiver, settings: nil, namespace: nil, attr_name: nil)
            attr_name ||= :net_http
            settings ||= Settings.instance
            namespace = Array(namespace)

            host = settings.get *namespace, :host
            port = settings.get *namespace, :port
            read_timeout = settings.get *namespace, :read_timeout

            net_http = Net::HTTP.new host, port

            net_http.read_timeout = read_timeout if read_timeout

            receiver.public_send "#{attr_name}=", net_http

            net_http
          end

          class Substitute
            attr_writer :response_body
            attr_accessor :status_code
            attr_accessor :started

            setting :host
            setting :port

            def self.build
              instance = new
              Settings.set instance
              instance
            end

            def address
              host
            end

            def request_get(path, initheader=nil)
              status_code = get_request_status_code

              OpenStruct.new(
                :code => status_code,
                :body => response_body
              )
            end

            def request_post(path, request_body, initheader=nil)
              status_code = post_request_status_code

              OpenStruct.new(
                :code => status_code,
                :body => response_body
              )
            end

            def start
              self.started = true
            end

            def started?
              started ? true : false
            end

            def response_body
              @response_body ||= Defaults.response_body
            end

            def get_request_status_code
              status_code || Defaults.get_request_status_code
            end

            def post_request_status_code
              status_code || Defaults.post_request_status_code
            end

            def set_response(status_code, response_body=nil)
              self.status_code = status_code
              self.response_body = response_body if response_body
            end

            module Defaults
              def self.get_request_status_code
                404
              end

              def self.post_request_status_code
                201
              end

              def self.response_body
                ''
              end
            end
          end
        end
      end
    end
  end
end
