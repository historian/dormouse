Rails.application.routes.draw do

  Rails.application.config.dormouse.resources.each do |resource|
    resource = resource.classify.constantize
    Dormouse::ActionController::Builder.build(resource.manifest, self)
  end

end