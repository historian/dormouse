# @author Simon Menke
class Dormouse::Manifest

  extend ActiveSupport::Memoizable
  include Enumerable

  def initialize(resource)
    @collection_type = :list
    @style           = Dormouse.style
    @namespace       = Dormouse.default_namespace

    @resource   = resource
    @properties = Dormouse::OrderedHash.new
    @names      = Dormouse::Names.new(@resource, nil, nil, false)
    @urls       = Dormouse::URLs.new(@names, nil, @namespace)
    @widgets    = Dormouse::Widgets.new(self)
    @sidebars   = Dormouse::Sidebars.new(self)

    generate_default_properties

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
  end

  # the resource class (must be an instance of ActiveRecord::Base)
  # @return [Class]
  attr_reader :resource

  # A helper for building names for this resource.
  # @return [Dormouse::Names]
  attr_reader :names

  # A helper for building urls to this resource.
  # @return [Dormouse::URLs]
  attr_reader :urls

  # The list of form widgets.
  # @return [Dormouse::Widgets]
  attr_reader :widgets

  # The list of sidebars.
  # @return [Dormouse::Sidebars]
  attr_reader :sidebars

  # The name of the column representing the primary name of this resource. this is displayed as the clickable link in a list or tree.
  # @return [String]
  attr_accessor :primary_name_column

  # The name of the column representing the secondary name of this resource. this is displayed below the clickable link in a list or tree.
  # @return [String]
  attr_accessor :secondary_name_column

  attr_accessor :children_association

  # The style used to render this resource. defaults to `'dormouse'`.
  # @return [Symbol]
  attr_accessor :style

  # The namespace used for this resource.
  # @return [String]
  attr_accessor :namespace

  # The collection type of this resource. Possible options are `list`, `:tree` and `:grid`
  # @return [Symbol]
  attr_accessor :collection_type

  # get a property by name. `:_primary` and `:_secondary` are shortcuts to the `primary_name_column` and `secondary_name_column` properties.
  # @param [String, Symbol] name The name of the property
  # @return [Dormouse::Property]
  def [](name)
    name = expand_property_name(name)
    @properties[name.to_s]
  end

  # @return [Array<String>]
  def properties
    @properties.sort!
    @properties.keys
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
    @widgets = nil
    self
  end

  # Delete a property from the manifest.
  def delete(name)
    name = expand_property_name(name)
    @properties.delete(name.to_s)
  end

  # @return [String]
  def inspect
    "#<#{self.class}: #{@resource}>"
  end


  # Push a new property.
  # @return [Dormouse::Property]
  def push(property_or_name)
    property = property_or_name
    if String === property_or_name or Symbol === property_or_name
      property = Dormouse::Property.new(self, property_or_name)
    end
    @properties[property.names.id] = property
    property
  end

  attr_accessor :owner
  def owner
    @owner || default_owner
  end

  attr_reader :ownees
  def ownees
    @ownees ||= begin
      self.inject([]) do |memo, prop|
        next(memo) unless prop.type == :has_one or prop.type == :has_many
        prop_owner = prop.resource.manifest.owner
        next(memo) unless prop_owner == @resource.to_s

        memo << prop.names.id
        memo
      end
    end
  end

private

  def default_owner
    potential_owners = self.select do |property|
      property.type == :belongs_to
    end

    if potential_owners.size == 1
      property = potential_owners.first
      unless FalseClass === property.options[:owner]
        return property.resource.to_s
      end
    end

    potential_owners = potential_owners.select do |property|
      property.options[:owner]
    end

    if potential_owners.size == 1
      property = potential_owners.first
      return property.resource.to_s
    else
      nil
    end
  end
  memoize :default_owner

  def expand_property_name(name)
    name = primary_name_column   if name == :_primary
    name = secondary_name_column if name == :_secondary
    name = children_association  if name == :_children
    name
  end

  def generate_default_properties
    resource.content_columns.each do |column|
      property = Dormouse::Property.new(self, column, resource.table_name)
      @properties[property.names.id] = property
    end

    resource.reflect_on_all_associations.each do |association|
      property = Dormouse::Property.new(self, association)
      @properties[property.names.association_id] = property
    end

    (Dormouse.options[:extensions] || []).each do |extention|
      extention = (Class === extention ? extention : extention.constantize)
      extention.define(self) if extention.respond_to?(:call)
    end

  rescue ActiveRecord::StatementInvalid => e
    puts "#{e.message}"
  end

end