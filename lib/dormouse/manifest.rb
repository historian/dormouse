# @author Simon Menke
class Dormouse::Manifest

  include Enumerable

  COLLECTION_TYPES = [:list, :tree, :grid]

  def initialize(resource)
    @resource   = resource
    @properties = Dormouse::OrderedHash.new

    @tabs       = Dormouse::Tabs.new(self)

    generate_default_properties

    @style               = Dormouse.options[:style]
    @namespace           = Dormouse.options[:default_namespace]
    @collection_type     = :list
    @primary_name_column = begin
      if @properties.key? :name
        :name
      elsif @properties.key? :title
        :title
      else
        @properties.keys.first
      end
    end

    self[:created_at].populate(:hidden => true) if self[:created_at]
    self[:updated_at].populate(:hidden => true) if self[:updated_at]
    self[:position].populate(:hidden => true)   if self[:position]

    @tabs.reset!
  end

  # the resource class (must be an instance of ActiveRecord::Base)
  # @return [Class]
  attr_reader :resource

  # A helper for building names for this resource.
  # @return [Dormouse::Names]
  attr_reader :names
  def names
    @names ||= Dormouse::Names.new(resource, nil)
  end

  # A helper for building urls to this resource.
  # @return [Dormouse::URLs]
  attr_reader :urls
  def urls
    @urls ||= Dormouse::URLs.new(self.names, nil)
  end

  # The list of form widgets.
  # @return [Dormouse::Widgets]
  attr_reader :widgets
  def widgets
    @widgets ||= Dormouse::Widgets.new(self)
  end

  # The list of sidebars.
  # @return [Dormouse::Sidebars]
  attr_reader :sidebars
  def sidebars
    @sidebars ||= Dormouse::Sidebars.new(self)
  end

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

  # The namespace used for this resource.
  # @return [String]
  attr_accessor :namespace

  # The collection type of this resource. Possible options are <tt>list</tt>, <tt>:tree</tt> and <tt>:grid</tt>
  # @return [Symbol]
  attr_accessor :collection_type

  # get a property by name. <tt>:_primary</tt> and <tt>:_secondary</tt> are shortcuts to the <tt>primary_name_column</tt> and <tt>secondary_name_column</tt> properties.
  # @param [String, Symbol] name The name of the property
  # @return [Dormouse::Property]
  def [](name)
    name = expand_property_name(name)
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

  # reset any cached values.
  def reset!
    @tabs.reset!
    @widgets = nil
    self
  end

  # Delete a property from the manifest.
  def delete(name)
    name = expand_property_name(name)
    @properties.delete(name.to_sym)
  end

  def inspect
    "#<#{self.class}: #{@resource}>"
  end


  # Push a new property.
  def push(property_or_name)
    property = property_or_name
    if String === property_or_name
      property = Dormouse::Property.new(self, property_or_name)
    end
    @properties[property.names.param] = property
    property
  end

private

  def expand_property_name(name)
    name = primary_name_column   if name == :_primary
    name = secondary_name_column if name == :_secondary
    name = children_association  if name == :_children
    name
  end

  def generate_default_properties
    resource.content_columns.each do |column|
      property = Dormouse::Property.new(self, column)
      @properties[property.names.param] = property
    end

    resource.reflect_on_all_associations.each do |association|
      property = Dormouse::Property.new(self, association)
      @properties[property.names.param] = property
    end

    (Dormouse.options[:extentions] || []).each do |extention|
      extention = (Class === extention ? extention : extention.constantize)
      extention.call(self) if extention.respond_to?(:call)
    end

  rescue ActiveRecord::StatementInvalid => e
    puts "#{e.message}"
  end

end