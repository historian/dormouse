Rails::Application.routes.draw do |map|

  Dormouse.options[:resources].each do |resource|
    resource = resource.classify.constantize
    resource.manifest.mount(map)
  end

end