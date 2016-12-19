ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init.rb'
require 'event_source/event_store/http/controls'

require 'test_bench'; TestBench.activate

require 'pp'

EventStore = EventSource::EventStore
Controls = EventSource::EventStore::HTTP::Controls
