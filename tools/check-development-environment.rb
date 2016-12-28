#!/usr/bin/env ruby

require_relative '../init'

require 'event_source/event_store/http/controls'

require 'socket'

port = EventSource::EventStore::HTTP::Controls::Port.example

unless File.exist? 'event-store/run-node.sh'
  warn <<~TEXT

  The startup script that belongs to the EventStore package was not found
  locally under `event-store/run-node.sh`. Ensure that `event-store` is a
  working symbolic link that references a recent version of EventStore's
  distribution. EventStore can be downloaded here:

      https://geteventstore.com/downloads/


  TEXT

  fail
end

begin
  TCPSocket.new '127.0.0.1', port
rescue Errno::ECONNREFUSED
  warn <<~TEXT

  EventStore is not running on 127.0.0.1 port #{port}. Run the
  following command to start it:

      tools/start-event-store

  TEXT

  fail
end

cluster_ip_addresses = EventSource::EventStore::HTTP::Controls::Cluster::IPAddress::List.example

cluster_ip_addresses.each do |ip_address|
  begin
    server = TCPServer.new ip_address, port
    server.close
  rescue Errno::EADDRNOTAVAIL
    warn <<~TEXT

    Loopback IP address #{ip_address.inspect} cannot be bound. On OSX systems,
    anay loopback address other than 127.0.0.1 must be aliased explicitly like this:

        sudo ifconfig lo0 alias #{ip_address} up

    This operation may not be necessary on other UNIX platforms, but if it *is*
    necessary, the command is almost certainly going to differ.


    TEXT

    fail
  rescue Errno::EADDRINUSE
  end

  begin
    TCPSocket.new ip_address, port
  rescue Errno::ECONNREFUSED
    warn <<~TEXT

    EventStore cluster node is not running on #{ip_address} port #{port}. Run
    the following command to start one:

        tools/start-event-store-cluster-node #{ip_address}

    TEXT

    fail
  end
end

begin
  TCPSocket.new '127.0.0.1', 10053
rescue Errno::ECONNREFUSED
  warn <<~TEXT

  Test DNS server is not running on port 10053. Run the following command to
  start it:

      tools/start-test-dns-server

  TEXT

  fail
end
