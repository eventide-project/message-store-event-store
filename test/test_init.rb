ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init.rb'
require 'event_source/event_store/http/controls'

require 'test_bench'; TestBench.activate

require 'pp'

Controls = EventSource::EventStore::HTTP::Controls

Net::HTTP.send :const_set, :Assertions, EventSource::EventStore::HTTP::Connect::NetHTTP::Assertions
