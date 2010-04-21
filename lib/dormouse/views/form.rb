class Dormouse::Views::Form < Dormouse::Views::Base
  
  def render(object=nil)
    manifest = self.manifest
    
    widgets  = self.widgets
    tabs     = self.tabs
    
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
      @tabs     = tabs
      
      @save_url = begin
        if object.new_record?
          File.dirname(request.path)
        else
          manifest.object_url(object)
        end
      end
      
      if request.xhr?
        render :template => "#{manifest.style}/views/form",
               :layout   => false
      else
        render :template => "#{manifest.style}/views/form",
               :layout   => "#{manifest.style}/layouts/dormouse"
      end
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
  
  def tabs
    @tabs ||= begin
      manifest.inject([]) do |memo, property|
        
        if property.type == :has_many and !property.options[:inline]
          memo << Dormouse::Tab.new(manifest, property)
        end
        
        memo
      end
    end
  end
  
end