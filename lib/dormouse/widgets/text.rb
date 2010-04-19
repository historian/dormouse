class Dormouse::Widgets::Text < Dormouse::Widgets::Base
  
  def render(object, options={})
    value = object.__send__(@property.name)
    locals = options.merge( :value => value, :object => object, :property => @property, :manifest => @manifest )
    view_eval { render :partial => "#{manifest.style}/widgets/text", :locals => locals }
  end
  
end