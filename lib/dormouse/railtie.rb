# @author Simon Menke
class Dormouse::Railtie < Rails::Engine

  config.dormouse = ActiveSupport::OrderedOptions.new
  config.dormouse.merge! Dormouse::DEFAULT_OPTIONS

  initializer "dormouse.setup_configuration" do |app|
    Dormouse.options.merge! app.config.dormouse
  end

end