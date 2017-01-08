module EventSource
  module EventStore
    module HTTP
      module Controls
        module Request
          module Post
            class SimulateWriteTimeout < Module
              def self.extend(receiver, error_count=nil)
                error_count ||= 1

                mod = new error_count
                receiver.extend mod
                mod
              end

              initializer :error_count

              def extended(request)
                request.singleton_class.class_exec error_count do |error_count|

                  define_method :call do |path, json_text, expected_version: nil|
                    if error_count == 0
                      super(path, json_text, expected_version: expected_version)
                    else
                      error_count -= 1

                      error = ::EventSource::EventStore::HTTP::Request::Post::WriteTimeoutError
                      raise error
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
