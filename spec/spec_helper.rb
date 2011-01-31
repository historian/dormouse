require 'rubygems'

$:.unshift(File.expand_path('../../lib', __FILE__))

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

require 'dormouse'

def i(string)
  string =~ /\A(?:^\s+\n)*(?:^(\s*)\S)/m
  indent = Regexp.escape($1 || '')
  string.gsub(/^#{indent}/, '')
end

module ModelBuilder

  def using_in_memory_database
    @defined_tables = {}
    @defined_models = {}
    @undefs_after   = []

    tables =  @defined_tables
    models =  @defined_models
    undefs =  @undefs_after

    before :all do
      begin
        $stdout = StringIO.new

        ActiveRecord::Base.establish_connection(
          :adapter => 'sqlite3', :database => ':memory:')

        ActiveRecord::Schema.define do
          tables.each do |name, block|
            create_table(name, :force => true, &block)
          end
        end
      rescue
        print $stdout.string
      ensure
        $stdout = STDOUT
      end

      models.each do |name, block|
        parts  = name.split('::')
        klass  = parts.pop
        parent = Object

        parent = parts.inject(parent) do |parent, name|
          unless parent.const_defined?(name)
            mod = Module.new
            parent.send :const_set, name, mod
            undefs << [parent, name]
          end
          parent.send :const_get, name
        end

        undefs << [parent, klass]
        model = Class.new(ActiveRecord::Base)
        model.class_eval(&block)
        parent.send :const_set, klass, model
      end

    end

    after :all do

      undefs.reverse.each do |(parent, name)|
        parent.send :remove_const, name
      end

      undefs.clear

    end
  end

  def let_table(name, &block)
    @defined_tables[name.to_s] = block
  end

  def let_model(name, &block)
    @defined_models[name] = block
  end

end