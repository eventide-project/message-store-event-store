module EventSource
  module EventStore
    module HTTP
      module Controls
        module Settings
          module Cluster
            def self.example
              Available.example
            end

            def self.size
              3
            end

            module Available
              def self.example
                hostname = Hostname.example

                Settings.example hostname: hostname
              end

              module Hostname
                def self.example
                  'eventstore-cluster.example'
                end
              end

              module IPAddress
                def self.example(i=nil)
                  i ||= 1

                  "127.0.111.#{i}"
                end

                module List
                  def self.example
                    (1..Cluster.size).map do |i|
                      IPAddress.example i
                    end
                  end
                end
              end
            end

            module Unavailable
              def self.example
                hostname = Hostname.example

                Settings.example hostname: hostname
              end

              module Hostname
                def self.example
                  'eventstore-cluster-unavailable.example'
                end
              end

              module IPAddress
                def self.example(i=nil)
                  i ||= 1

                  "127.0.222.#{i}"
                end

                module List
                  def self.example
                    (1..Cluster.size).map do |i|
                      IPAddress.example i
                    end
                  end
                end
              end
            end

            module PartiallyAvailable
              def self.example
                hostname = Hostname.example

                Settings.example hostname: hostname
              end

              module Hostname
                def self.example
                  'eventstore-cluster-partially-available.example'
                end
              end

              module IPAddress
                def self.example(i=nil)
                  i ||= 1

                  if i == 1
                    Unavailable.example i
                  else
                    Available.example i
                  end
                end

                module List
                  def self.example
                    (1..Cluster.size).map do |i|
                      IPAddress.example i
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
