Rails::Application.routes.draw do |map|

  Dormouse.options[:resources].each do |resource|
    resource = resource.classify.constantize
    Dormouse::ActionController::Builder.build(resource.manifest, map)
  end

end