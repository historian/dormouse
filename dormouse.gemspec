# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler'
require 'dormouse/version'

Gem::Specification.new do |s|
  s.name        = "dormouse"
  s.version     = Dormouse::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Menke"]
  s.email       = ["simon.menke@gmail.com"]
  s.homepage    = "http://github.com/fd/dormouse"
  s.summary     = "ActiveRecord models are so wise, we should use there wisdom instead of being stubborn and stupid."
  s.description = "Build CMS's in a snap using just models."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "dormouse"

  s.files        = Dir.glob("{app,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)
  s.require_path = 'lib'

  s.add_bundler_dependencies
end