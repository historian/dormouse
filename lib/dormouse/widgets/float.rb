class Dormouse::Widgets::Float < Dormouse::Widgets::Base
  
  def render(object, options={})
    value = object.__send__(@property.name)
    locals = options.merge( :value => value, :object => object, :property => @property, :manifest => @manifest )
    view_eval { render :partial => 'dormouse/widgets/float', :locals => locals }
  end
  
end