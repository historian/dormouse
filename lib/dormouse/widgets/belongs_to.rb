class Dormouse::Widgets::BelongsTo < Dormouse::Widgets::Base
  
  property_type :belongs_to
  
  def render(object, options={})
    value = object.__send__(@property.name)
    locals = options.merge( :value => value, :object => object, :property => @property, :manifest => @manifest, :target => @property.resource.manifest )
    view_eval { render :partial => "#{manifest.style}/widgets/belongs_to", :locals => locals }
  end
  
end