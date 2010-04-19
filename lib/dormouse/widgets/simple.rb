class Dormouse::Widgets::Simple < Dormouse::Widgets::Base
  
  def render(object, options={})
    value = object.__send__(@property.name)
    locals = options.merge( :value => value, :object => object, :property => @property, :manifest => @manifest )
    property_type = self.property_type
    view_eval { render :partial => "#{manifest.style}/widgets/#{property_type}", :locals => locals }
  end
  
end