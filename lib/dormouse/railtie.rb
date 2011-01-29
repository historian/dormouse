# @author Simon Menke
class Dormouse::Railtie < Rails::Engine

  config.dormouse = ActiveSupport::OrderedOptions.new
  config.dormouse.style                 = 'dormouse',
  config.dormouse.controller_superclass = 'ApplicationController',
  config.dormouse.extentions            = %w(
      Dormouse::Extentions::Globalize
      Dormouse::Extentions::Paperclip
      Dormouse::Extentions::LalalaAssets ),
  config.dormouse.cms_name              = 'Administration',
  config.dormouse.resources             = [],
  config.dormouse.default_namespace     = nil

end