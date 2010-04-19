class Dormouse::Manifest
  
  include Enumerable
  
  def initialize(resource)
    @resource   = resource
    @properties = {}
    @order      = []
    
    generate_default_properties
  end
  
  attr_reader :resource, :order
  attr_accessor :primary_name_column, :secondary_name_column
  
  def mount
    Dormouse::ActionController.build(self)
  end
  
  def render_list(controller, collection=nil)
    @list_view ||= Dormouse::Views::List.new(self)
    @list_view.render_in_controller(controller, collection)
  end
  
  def render_form(controller, object=nil)
    @form_view ||= Dormouse::Views::Form.new(self)
    @form_view.render_in_controller(controller, object)
  end
  
  def [](name)
    @properties[name.to_sym]
  end
  
  def each
    @order.each do |name|
      yield @properties[name]
    end
    self
  end
  
  def controller_superclass
    ApplicationController
  end
  
  def controller_class
    @controller_class ||= "#{resource}::ResourcesController".constantize
  end
  
  def primary_name_column
    @primary_name_column || @properties[@order.first].name
  end
  
private
  
  def generate_default_properties
    resource.content_columns.each do |column|
      property = Dormouse::Property.new(self, column)
      @properties[property.name] = property
      @order << property.name
    end
    
    resource.reflect_on_all_associations.each do |association|
      property = Dormouse::Property.new(self, association)
      @properties[property.name] = property
      @order << property.name
    end
  end
  
end