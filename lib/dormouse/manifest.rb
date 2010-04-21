class Dormouse::Manifest
  
  include Enumerable
  
  COLLECTION_TYPES = [:list]
  
  def initialize(resource)
    @resource   = resource
    @properties = {}
    @order      = []
    @names      = Dormouse::Names.new(self)
    @urls       = Dormouse::Urls.new(self)
    
    generate_default_properties
  end
  
  attr_reader :resource, :order, :names, :urls
  attr_accessor :primary_name_column, :secondary_name_column
  attr_accessor :style, :collection_type
  
  def mount(map)
    Dormouse::ActionController.build(self, map)
  end
  
  def render_collection(controller, collection=nil)
    case collection_type.to_sym
    when :list then render_list(controller, collection)
    when :grid then render_grid(controller, collection)
    end
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
    @controller_superclass ||= begin
      Dormouse.options[:controller_superclass].constantize
    end
  end
  
  def controller_class
    @controller_class ||= names.controller_class_name.constantize
  end
  
  def style
    @style ||= Dormouse.options[:style]
  end
  
  def collection_type
    @collection_type ||= :list
  end
  
  def primary_name_column
    @primary_name_column ||= @properties[@order.first].name
  end
  
  def inspect
    "#<#{self}: #{@resource}>"
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
  rescue ActiveRecord::StatementInvalid => e
    puts "#{e.message}"
  end
  
end