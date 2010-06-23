# @author Simon Menke
module Dormouse

  require 'dormouse/version'

  require 'dormouse/configuration'
  require 'dormouse/ordered_hash'
  require 'dormouse/manifest'
  require 'dormouse/property'
  require 'dormouse/names'
  require 'dormouse/urls'
  require 'dormouse/dsl'
  require 'dormouse/widgets'
  require 'dormouse/extentions'
  require 'dormouse/sidebars'

  # I don't like these. There should be a more semantic solution to link data and represent this in the ui.
  require 'dormouse/menu'
  require 'dormouse/tab'

  require 'dormouse/active_record'
  require 'dormouse/action_controller'

  if defined?(Rails::Railtie)
    require 'dormouse/railtie'
  end

end