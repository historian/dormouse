# The DSL is used by the <tt>#manifest</tt> macro in ActiveRecord::Base to set 
# options on properties.
# 
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
class Dormouse::DSL
  
  def initialize(manifest)
    @manifest = manifest
  end
  
  # set the view style for this model. (The default style is :dormouse)
  def style(name)
    @manifest.style = (name || 'dormouse')
    self
  end
  
  # set the collection view type for this model. (The default type is :list)
  def collection_type(type)
    type = (type || :list).to_sym
    
    allowed_types = Dormouse::Manifest::COLLECTION_TYPES
    unless allowed_types.include?(type)
      raise ArgumentError, "Invalid collection type: #{type.inspect} (must be in #{allowed_types.inspect})"
    end
    
    @manifest.collection_type = type
    self
  end
  
  def menu(name, options={})
    Dormouse::menu.register(name, @manifest, options)
  end
  
  # set the primary name for a model. The primary name is the name shown in lists, select boxes and grids as the link to the details.
  def primary_name(property)
    set(property, :primary => true)
  end
  
  # set the secondary name for a model. The secondary name is the name shown in lists and grids as the tag line.
  def secondary_name(property)
    set(property, :secondary => true)
  end
  
  # hide one or more properties in the form.
  def hide(*properties)
    properties.each do |property|
      set(property, :hidden => true)
    end
    self
  end
  
  # show one or more properties in the form.
  def show(*properties)
    properties.each do |property|
      set(property, :hidden => false)
    end
    self
  end
  
  # set  a custom label for a property
  def label(property, label=nil)
    set(property, :label => label)
  end
  
  # reorder one or more properties in the form.
  def order(*properties)
    options = properties.extract_options!
    if options[:after]
      properties = properties.reverse
    end
    properties.each do |property|
      set(property, options.dup)
    end
    self
  end
  
  def set(property, options={})
    property = property.to_sym
    
    order_options = options.slice(:after, :before, :top, :bottom)
    options.except!(:after, :before, :top, :bottom)
    case 
    when hook = order_options[:after]
      idx = @manifest.order.index(hook.to_sym) || (@manifest.size - 1)
      @manifest.order.delete(property)
      @manifest.order.insert(idx + 1, property)
    when hook = order_options[:before]
      idx = @manifest.order.index(hook.to_sym) || (@manifest.size - 1)
      @manifest.order.delete(property)
      @manifest.order.insert(idx, property)
    when order_options[:top]
      @manifest.order.delete(property)
      @manifest.order.insert(0, property)
    when order_options[:bottom]
      @manifest.order.delete(property)
      @manifest.order.push(property)
    end
    
    if options.key?(:primary) and options.delete(:primary)
      @manifest.primary_name_column = property 
    end
    
    if options.key?(:secondary) and options.delete(:secondary)
      @manifest.secondary_name_column = property
    end
    
    @manifest[property].populate(options)
    
    self
  end
  
end