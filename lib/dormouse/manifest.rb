# @author Simon Menke
class Dormouse::Manifest

  include Enumerable

  COLLECTION_TYPES = [:list, :tree, :grid]

  def initialize(resource)
    @resource   = resource
    @properties = Dormouse::OrderedHash.new
    @names      = Dormouse::Names.new(self)
    @urls       = Dormouse::Urls.new(self)
    @widgets    = Dormouse::Widgets.new(self)
    @tabs       = Dormouse::Tabs.new(self)

    generate_default_properties

    @style               = Dormouse.options[:style]
    @collection_type     = :list
    @primary_name_column = @properties.keys.first

    self[:created_at].populate(:hidden => true) if self[:created_at]
    self[:updated_at].populate(:hidden => true) if self[:updated_at]
    self[:position].populate(:hidden => true)   if self[:position]

    @widgets.reset!
    @tabs.reset!
  end

  # the resource class (must be an instance of ActiveRecord::Base)
  # @return [Class]
  attr_reader :resource

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

  attr_accessor :children_association

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
    name = children_association  if name == :_children
    @properties[name.to_sym]
  end

  # loop over each property in the specified order.
  # @yield [property]
  # @yieldparam [Dormouse::Property] property
  # @return [Dormouse::Manifest] self
  def each
    @properties.sort!
    @properties.each_value do |property|
      yield property
    end
    self
  end

  def delete(name)
    name = primary_name_column   if name == :_primary
    name = secondary_name_column if name == :_secondary
    name = children_association  if name == :_children
    @properties.delete(name.to_sym)
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

  def push(property_or_name)
    property = property_or_name
    if String === property_or_name
      property = Dormouse::Property.new(self, property_or_name)
    end
    @properties[property.name] = property
    property
  end

private

  def generate_default_properties
    resource.content_columns.each do |column|
      property = Dormouse::Property.new(self, column)
      @properties[property.name] = property
    end

    resource.reflect_on_all_associations.each do |association|
      property = Dormouse::Property.new(self, association)
      @properties[property.name] = property
    end

    (Dormouse.options[:extentions] || []).each do |extention|
      extention = (Class === extention ? extention : extention.constantize)
      extention.call(self)
    end

  rescue ActiveRecord::StatementInvalid => e
    puts "#{e.message}"
  end

end