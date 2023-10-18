# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name        = 'gemegen'
  s.version     = '0.0.1'
  s.author      = ['Bartek Wilczek']
  s.email       = ['bartek.wilczek@toptal.com']
  s.homepage    = 'http://github.com/toptal/gemegen'
  s.summary     = 'Generator of paragraph games'
  s.description = 'Generate the game as interactive HTML, from the provided YML manifest.'
  s.license     = 'MIT'
  s.required_ruby_version = '~> 3.2.0'

  s.files = Dir['**/*'].reject do |f|
    f.start_with?('spec') ||
      File.directory?(f)
  end
  s.require_path = 'lib'

  s.add_dependency 'parslet'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.metadata['rubygems_mfa_required'] = 'true'
end
