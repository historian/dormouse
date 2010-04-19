class Dormouse::DSL
  
  def initialize(manifest)
    @manifest = manifest
  end
  
  def primary_name(property)
    set(property, :primary => true)
  end
  
  def secondary_name(property)
    set(property, :secondary => true)
  end
  
  def hide(*properties)
    properties.each do |property|
      set(property, :hidden => true)
    end
    self
  end
  
  def show(*properties)
    properties.each do |property|
      set(property, :hidden => false)
    end
    self
  end
  
  def label(property, label=nil)
    set(property, :label => label)
  end
  
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