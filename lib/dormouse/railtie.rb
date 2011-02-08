# @author Simon Menke
class Dormouse::Railtie < Rails::Engine

  config.dormouse = ActiveSupport::OrderedOptions.new
  config.dormouse.merge! Dormouse::DEFAULT_OPTIONS

end