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
  require 'dormouse/sidebars'

  module Extensions
    require 'dormouse/extensions/paperclip'
    require 'dormouse/extensions/blackbird_i18n'
    require 'dormouse/extensions/lalala_assets'
  end

  require 'dormouse/active_record'
  require 'dormouse/action_controller'

  if defined?(Rails::Railtie)
    require 'dormouse/railtie'
  end

end