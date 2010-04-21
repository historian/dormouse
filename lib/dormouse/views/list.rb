class Dormouse::Views::List < Dormouse::Views::Base
  
  def render(collection=nil)
    manifest = self.manifest
    
    collection ||= manifest.resource.all
    
    controller_eval do
      @collection = collection
      render :template => "#{manifest.style}/views/list", :layout => "#{manifest.style}/layouts/application"
    end
  end
  
end