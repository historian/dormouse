#
# The DSL is used by the `#manifest` macro in ActiveRecord::Base to set
# options on properties.
#
# @example A simple post model
#   class Post < ActiveRecord::Base
#     validates :title, :presence => true
#
#     manifest do
#       order :published_on, :before => :body
#       set :body, :label => false
#       hide :created_at, :updated_at
#       primary_name :title
#     end
#   end
#
# @author Simon Menke
#
class Dormouse::DSL


  def initialize(manifest)
    @manifest = manifest
  end


  # set the view style for this model. (The default style is :dormouse)
  # @return [Dormouse::DSL] self
  def style(name)
    @manifest.style = (name || 'dormouse')
    self
  end


  # set the namespace for this resource.
  # @return [Dormouse::DSL] self
  def namespace(string)
    @manifest.namespace = (string || false)
    self
  end


  # set the collection view type for this model. (The default type is :list)
  # @return [Dormouse::DSL] self
  def collection_type(type)
    type = (type || :list).to_sym
    @manifest.collection_type = type
    self
  end


  # set the primary name for a model. The primary name is the name shown in lists, select boxes and grids as the link to the details.
  # @return [Dormouse::DSL] self
  def primary_name(property)
    set(property, :primary => true)
  end


  # set the secondary name for a model. The secondary name is the name shown in lists and grids as the tag line.
  # @return [Dormouse::DSL] self
  def secondary_name(property)
    set(property, :secondary => true)
  end


  def children(property)
    set(property, :children => true)
  end


  def sidebar(type, options={})
    @manifest.sidebars[type.to_sym] ||= Dormouse::Sidebar.new(type.to_sym, options)
    @manifest.sidebars[type.to_sym].populate(options)
    self
  end


  # hide one or more properties in the form.
  # @param [#to_sym] properties property names
  # @return [Dormouse::DSL] self
  def hide(*properties)
    properties.each do |property|
      set(property, :hidden => true)
    end
    self
  end


  # show one or more properties in the form.
  # @param [#to_sym] properties property names
  # @return [Dormouse::DSL] self
  def show(*properties)
    properties.each do |property|
      set(property, :hidden => false)
    end
    self
  end


  # set  a custom label for a property
  # @param [#to_sym] property property name
  # @param [String, false, nil] label property label
  # @return [Dormouse::DSL] self
  def label(property, label=nil)
    set(property, :label => label)
  end


  # @overload order(*properties, options={})
  #   Reorder one or more properties in the form.
  #   @param [#to_sym] properties property names
  #   @option options [Symbol] :after (nil) position this property after another property.
  #   @option options [Symbol] :before (nil) position this property before another property.
  #   @option options [Boolean] :top (false) position this property at the top.
  #   @option options [Boolean] :bottom (false) position this property at the bottom.
  #   @return [Dormouse::DSL] self
  def order(*properties)
    options = properties.extract_options!
    properties.each do |property|
      set(property, options.dup)
    end
    self
  end


  def add(name, options={})
    @manifest.push(name)
    set(name, options)
  end


  # Set options for a property.
  # @param [#to_sym] name of the property
  # @option options [Symbol] :after (nil) position this property after another property.
  # @option options [Symbol] :before (nil) position this property before another property.
  # @option options [Boolean] :top (false) position this property at the top.
  # @option options [Boolean] :bottom (false) position this property at the bottom.
  # @option options [Boolean] :primary (false) make this property the primary property.
  # @option options [Boolean] :secondary (false) make this property the secondary property.
  # @option options [Boolean] :hidden (false) make this property hidden.
  # @option options [String, false, nil] :label (nil) set the label for the property.
  # @return [Dormouse::DSL] self
  def set(property, options={})
    property = property.to_sym

    return self unless @manifest[property]

    if options.key?(:primary) and options.delete(:primary)
      @manifest.primary_name_column = property
    end

    if options.key?(:secondary) and options.delete(:secondary)
      @manifest.secondary_name_column = property
    end

    if options.key?(:children) and options.delete(:children)
      @manifest.children_association = property
    end

    @manifest[property].populate(options)

    self
  end

end