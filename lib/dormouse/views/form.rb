class Dormouse::Views::Form < Dormouse::Views::Base
  
  def render(object=nil)
    manifest = self.manifest
    
    widgets  = self.widgets
    
    object ||= begin
      if id = @controller.params[:id]
        manifest.resource.find(id)
      else
        manifest.resource.new
      end
    end
      
    controller_eval do
      @object   = object
      @widgets  = widgets
      render :template => "#{manifest.style}/views/form", :layout => "#{manifest.style}/layouts/dormouse"
    end
  end
  
  def widgets
    @widgets ||= begin
      manifest.inject([]) do |memo, property|
        widget_klass = Dormouse::Widgets[property.type]
        memo << widget_klass.new(manifest, property) if widget_klass
        memo
      end
    end
  end
  
end