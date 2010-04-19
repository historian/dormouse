class Dormouse::Widgets::HasMany < Dormouse::Widgets::Base
  
  property_type :has_many
  
  def render(object, options={})
    return unless @property.options[:inline]
    
    value = object.__send__(@property.name)
    locals = options.merge( :value => value, :object => object, :property => @property, :manifest => @manifest, :target => @property.resource.manifest )
    view_eval { render :partial => "#{manifest.style}/widgets/has_many", :locals => locals }
  end
  
end