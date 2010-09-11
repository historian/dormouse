# -*- encoding: utf-8 -*-
require File.expand_path("../lib/dormouse/version", __FILE__)

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

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.add_runtime_dependency 'rails', '~> 3.0'
end