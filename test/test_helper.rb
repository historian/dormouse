require 'rubygems'
require 'tempfile'
require 'test/unit'

require 'shoulda'
require 'mocha'

case ENV['RAILS_VERSION']
when '2.1' then
  gem 'activerecord',  '~>2.1.0'
  gem 'activesupport', '~>2.1.0'
  gem 'actionpack',    '~>2.1.0'
when '2.3' then
  gem 'activerecord',  '~>2.3.0'
  gem 'activesupport', '~>2.3.0'
  gem 'actionpack',    '~>2.3.0'
else
  gem 'activerecord',  '~>3.0.0'
  gem 'activesupport', '~>3.0.0'
  gem 'actionpack',    '~>3.0.0'
end

require 'active_record'
require 'active_record/version'
require 'active_support'
require 'action_pack'
require 'action_controller'
require 'action_view'
require 'rails'

ROOT = File.join(File.dirname(__FILE__), '..')
$LOAD_PATH << File.join(ROOT, 'lib')
require 'dormouse'
puts "Testing against version #{ActiveRecord::VERSION::STRING}"
