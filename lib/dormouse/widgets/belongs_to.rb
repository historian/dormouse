class Dormouse::Widgets::BelongsTo < Dormouse::Widgets::Base
  
  def render(object, options={})
    value = object.__send__(@property.name)
    locals = options.merge( :value => value, :object => object, :property => @property, :manifest => @manifest, :target => @property.resource.manifest )
    view_eval { render :partial => 'dormouse/widgets/belongs_to', :locals => locals }
  end
  
end