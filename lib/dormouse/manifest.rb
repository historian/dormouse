# @author Simon Menke
class Dormouse::Manifest
  
  include Enumerable
  
  COLLECTION_TYPES = [:list, :tree, :grid]
  
  def initialize(resource)
    @resource   = resource
    @properties = {}
    @order      = []
    @names      = Dormouse::Names.new(self)
    @urls       = Dormouse::Urls.new(self)
    @widgets    = Dormouse::Widgets.new(self)
    @tabs       = Dormouse::Tabs.new(self)
    
    generate_default_properties
    
    @style               = Dormouse.options[:style]
    @collection_type     = :list
    @primary_name_column = @properties[@order.first].name
    
    @widgets.reset!
    @tabs.reset!
  end
  
  # the resource class (must be an instance of ActiveRecord::Base)
  # @return [Class]
  attr_reader :resource
  
  # List of ordered property names
  # @return [Array<Symbol>]
  attr_reader :order
  
  # A helper for building names for this resource.
  # @return [Dormouse::Names]
  attr_reader :names
  
  # A helper for building urls to this resource.
  # @return [Dormouse::Urls]
  attr_reader :urls
  
  # The list of form widgets.
  # @return [Dormouse::Widgets]
  attr_reader :widgets
  
  # The list of tabs.
  # @return [Dormouse::Tabs]
  attr_reader :tabs
  
  # The name of the column representing the primary name of this resource. this is displayed as the clickable link in a list or tree.
  # @return [Symbol]
  attr_accessor :primary_name_column
  
  # The name of the column representing the secondary name of this resource. this is displayed below the clickable link in a list or tree.
  # @return [Symbol]
  attr_accessor :secondary_name_column
  
  # The style used to render this resource. defaults to <tt>'dormouse'</tt>.
  # @return [Symbol]
  attr_accessor :style
  
  # The collection type of this resource. Possible options are <tt>list</tt>, <tt>:tree</tt> and <tt>:grid</tt>
  # @return [Symbol]
  attr_accessor :collection_type
  
  # Mounts this resource. <tt>map</tt> must be a route mapper. this method draws all relevant routes for this resource.
  def mount(map)
    Dormouse::ActionController.build(self, map)
  end
  
  # get a property by name. <tt>:_primary</tt> and <tt>:_secondary</tt> are shortcuts to the <tt>primary_name_column</tt> and <tt>secondary_name_column</tt> properties.
  # @param [String, Symbol] name The name of the property
  # @return [Dormouse::Property]
  def [](name)
    name = primary_name_column   if name == :_primary
    name = secondary_name_column if name == :_secondary
    @properties[name.to_sym]
  end
  
  # loop over each property in the specified order.
  # @yield [property]
  # @yieldparam [Dormouse::Property] property
  # @return [Dormouse::Manifest] self
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
    
    translations_model = nil
    resource.reflect_on_all_associations.each do |association|
      if association.name.to_s == 'globalize_translations'
        translations_model = association.klass
        next
      end
      
      property = Dormouse::Property.new(self, association)
      @properties[property.name] = property
      @order << property.name
    end
    
    if translations_model
      translations_model.content_columns.each do |column|
        next if %w( created_at updated_at locale ).include? column.name.to_s
        property = Dormouse::Property.new(self, column, translations_model.table_name)
        @properties[property.name] = property
        @order << property.name
      end
    end
    
  rescue ActiveRecord::StatementInvalid => e
    puts "#{e.message}"
  end
  
end