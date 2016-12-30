#!/usr/bin/env ruby

require_relative '../init'

require 'event_source/event_store/http/controls'

require 'socket'

# at_exit is used to move the check procedure to the top of the file, above the
# implementation details of each check. [Nathan Ladd, Thu 29 Dec 2016]
at_exit do
  available_non_cluster_ip_address = EventSource::EventStore::HTTP::Controls::Settings::NonCluster::Available::IPAddress.example
  unavailable_non_cluster_ip_address = EventSource::EventStore::HTTP::Controls::Settings::NonCluster::Unavailable::IPAddress.example
  available_cluster_ip_addresses = EventSource::EventStore::HTTP::Controls::Settings::Cluster::Available::IPAddress::List.example
  unavailable_cluster_ip_addresses = EventSource::EventStore::HTTP::Controls::Settings::Cluster::Unavailable::IPAddress::List.example

  checks = [
    Checks::Symlink.new,
    Checks::LoopbackAlias.new(available_non_cluster_ip_address),
    Checks::PortOpen::EventStore.new(available_non_cluster_ip_address),
    Checks::LoopbackAlias.new(unavailable_non_cluster_ip_address)
  ]

  available_cluster_ip_addresses.each do |ip_address|
    checks << Checks::LoopbackAlias.new(ip_address)

    checks << Checks::PortOpen::EventStore::ClusterNode.new(ip_address)
  end

  unavailable_cluster_ip_addresses.each do |ip_address|
    checks << Checks::LoopbackAlias.new(ip_address)
  end

  Checks.run *checks
end

module Checks
  def self.run(*class_list)
    error_messages = class_list.flat_map do |cls|
      error_message = cls.()

      Array(error_message)
    end

    error_messages.each_with_index do |error_message, index|
      warn <<~TEXT
      
      #{TerminalColors::Apply.("Error ##{index.next}", fg: :yellow)}:

      #{error_message}
      TEXT
    end

    exit 1 if error_messages.any?

    puts <<~TEXT

    #{TerminalColors::Apply.("All development environment checks passed.", fg: :green)}

    TEXT
  end

  module Check
    Virtual::PureMethod.define self, :pass?
    Virtual::PureMethod.define self, :error_message

    def call
      passed = pass?

      passed ? nil : error_message
    end
  end

  class Symlink
    include Check

    def pass?
      File.exist? 'event-store/run-node.sh'
    end

    def error_message
      <<~TEXT
      The startup script that belongs to the EventStore package was not found
      locally under `event-store/run-node.sh`. Ensure that `event-store` is a
      working symbolic link that references a recent version of EventStore's
      distribution. EventStore can be downloaded here:

          https://geteventstore.com/downloads/
      TEXT
    end
  end

  class LoopbackAlias
    include Check

    initializer :ip_address

    def pass?
      server = TCPServer.new ip_address, port
      server.close
      true
    rescue Errno::EADDRNOTAVAIL
      false
    rescue Errno::EADDRINUSE
      true
    end

    def port
      EventSource::EventStore::HTTP::Controls::Settings::Port.example
    end

    def error_message
      <<~TEXT
      Loopback IP address #{ip_address.inspect} cannot be bound. On OSX systems,
      any loopback address other than 127.0.0.1 must be aliased explicitly like this:

          sudo ifconfig lo0 alias #{ip_address} up

      This operation may not be necessary on other UNIX platforms, but if it *is*
      necessary, the command is almost certainly going to differ.
      TEXT
    end
  end

  class PortOpen
    include Check

    abstract :port

    def pass?
      TCPSocket.new ip_address, port
      true
    rescue Errno::ECONNREFUSED
      false
    end

    class EventStore < PortOpen
      initializer :ip_address

      def port
        EventSource::EventStore::HTTP::Controls::Settings::Port.example
      end

      def error_message
        <<~TEXT
        EventStore is not running on #{ip_address} port #{port}. Run the
        following command to start it:

            tools/start-event-store #{ip_address}
        TEXT
      end

      class ClusterNode < EventStore
        def error_message
          <<~TEXT
          EventStore cluster node is not running on #{ip_address} port #{port}.
          Run the following command to start it:

              tools/start-event-store-cluster-node #{ip_address}
          TEXT
        end
      end
    end
  end
end
