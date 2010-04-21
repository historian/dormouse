class Dormouse::Views::List < Dormouse::Views::Base
  
  def render(collection=nil)
    manifest = self.manifest
    
    collection ||= manifest.resource.all
    
    controller_eval do
      @collection = collection
      if request.xhr?
        render :template => "#{manifest.style}/views/list",
               :layout   => false
      else
        render :template => "#{manifest.style}/views/list",
               :layout   => "#{manifest.style}/layouts/dormouse"
      end
    end
  end
  
end