require 'rubygems'

RAILS_ROOT = File.expand_path("../../", __FILE__) unless defined?(RAILS_ROOT)
gem 'rails', '2.3.4'

require 'active_support'
require "active_record"
require 'action_pack'
require 'action_mailer'
require 'initializer'

require 'active_support/test_case'
require 'shoulda'

require 'dormouse'

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :database => 'test.db'
})

ActiveRecord::Schema.define do
  create_table "admin_blog_post", :force => true do |t|
    t.column "title", :string
    t.column "body",  :text
  end
end

require File.expand_path("../fixtures/models", __FILE__)