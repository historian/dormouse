class Dormouse::Widgets::Base
  
  attr_reader :property
  
  def self.property_type(name=nil)
    if name
      @property_type = name
      Dormouse::Widgets[name] = self
    else
      @property_type
    end
  end
  
  def property_type
    self.class.property_type
  end
  
  def initialize(manifest, property)
    @manifest, @property = manifest, property
  end
  
  delegate :hidden, :options, :name, :to => :property
  
  def render_in_view(view, object, options={})
    @view = view
    render(object, options)
  end
  
  def render(object, options={})
    
  end
  
private
  
  def view_eval(&block)
    @view.instance_eval(&block)
  end
  
end