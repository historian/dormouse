class Dormouse::Views::List < Dormouse::Views::Base
  
  def render(collection=nil)
    manifest = self.manifest
    
    collection ||= manifest.resource.all
    
    controller_eval do
      @collection = collection
      render :template => 'dormouse/views/list', :layout => 'dormouse/layouts/dormouse'
    end
  end
  
end