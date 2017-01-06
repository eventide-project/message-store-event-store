module EventSource
  module EventStore
    module HTTP
      class Session
        module Build
          def build(settings=nil, namespace: nil)
            instance = new

            connect = ::EventStore::HTTP::Connect.configure(
              instance,
              settings,
              namespace: namespace
            )

            instance.host = connect.host
            instance.port = connect.port

            ::EventStore::Cluster::LeaderStatus::Get.configure instance, connect

            ::Telemetry.configure instance

            instance
          end
        end
      end
    end
  end
end
