# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'evt-event_source-event_store-http'
  s.version = '0.2.0.0.pre3'
  s.summary = "Event source client for EventStore's HTTP interface"
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/event-source-event-store-http'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.3'

  s.add_runtime_dependency 'evt-event_source'
  s.add_runtime_dependency 'evt-event_store-cluster-leader_status'

  s.add_development_dependency 'test_bench'
end
