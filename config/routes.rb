Rails::Application.routes.draw do

  Dormouse.options[:resources].each do |resource|
    resource = resource.classify.constantize
    Dormouse::ActionController::Builder.build(resource.manifest, self)
  end

end