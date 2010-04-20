module Dormouse
  
  require 'dormouse/version'
  
  require 'dormouse/manifest'
  require 'dormouse/property'
  require 'dormouse/names'
  require 'dormouse/dsl'
  require 'dormouse/menu'
  require 'dormouse/tab'
  require 'dormouse/widgets'
  require 'dormouse/views'
  
  require 'dormouse/active_record'
  require 'dormouse/action_controller'
  
  if defined?(Rails) and Rails.respond_to?(:application)
    require 'dormouse/railtie'
  end
  
end