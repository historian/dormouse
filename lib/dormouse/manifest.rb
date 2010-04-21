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
  
  # the resource class (must be an instance of ActiveRecord::Base)
  attr_reader :resource
  
  attr_reader :order # :nodoc:
  
  # A helper for building names for this resource. see Dormouse::Names
  attr_reader :names
  
  # A helper for building urls to this resource. see Dormouse::Urls
  attr_reader :urls
  
  # The name of the column representing the primary name of this resource. this is displayed as the clickable link in a list or tree.
  attr_accessor :primary_name_column
  
  # The name of the column representing the secondary name of this resource. this is displayed below the clickable link in a list or tree.
  attr_accessor :secondary_name_column
  
  # The style used to render this resource. defaults to <tt>'dormouse'</tt>.
  attr_accessor :style
  
  # The collection type of this resource. Possible options are <tt>list</tt>, <tt>:tree</tt> and <tt>:grid</tt>
  attr_accessor :collection_type
  
  # Mounts this resource. <tt>map</tt> must be a route mapper. this method draws all relevant routes for this resource.
  def mount(map)
    Dormouse::ActionController.build(self, map)
  end
  
  # Render a collection
  def render_collection(controller, collection=nil)
    case collection_type.to_sym
    when :list then render_list(controller, collection)
    when :tree then render_tree(controller, collection)
    when :grid then render_grid(controller, collection)
    end
  end
  
  def render_list(controller, collection=nil) # :nodoc:
    @list_view ||= Dormouse::Views::List.new(self)
    @list_view.render_in_controller(controller, collection)
  end
  
  # Render a form
  def render_form(controller, object=nil)
    @form_view ||= Dormouse::Views::Form.new(self)
    @form_view.render_in_controller(controller, object)
  end
  
  # get a property by name. <tt>:_primary</tt> and <tt>:_secondary</tt> are shortcuts to the <tt>primary_name_column</tt> and <tt>secondary_name_column</tt> properties.
  def [](name)
    name = primary_name_column   if name == :_primary
    name = secondary_name_column if name == :_secondary
    @properties[name.to_sym]
  end
  
  # loop over each property in the specified order.
  def each
    @order.each do |name|
      yield @properties[name]
    end
    self
  end
  
  # the superclass of the generated controller for this resource
  def controller_superclass
    @controller_superclass ||= begin
      Dormouse.options[:controller_superclass].constantize
    end
  end
  
  # the controller class for this resource
  def controller_class
    @controller_class ||= names.controller_class_name.constantize
  end
  
  def style # :nodoc:
    @style ||= Dormouse.options[:style]
  end
  
  def collection_type # :nodoc:
    @collection_type ||= :list
  end
  
  def primary_name_column # :nodoc:
    @primary_name_column ||= @properties[@order.first].name
  end
  
  def inspect # :nodoc:
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