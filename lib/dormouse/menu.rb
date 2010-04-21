class Dormouse::Menu
  
  include Enumerable
  
  def initialize
    @items = {}
    @order = []
  end
  
  def each
    @order.each do |name|
      yield @items[name]
    end
  end
  
  def register(name, manifest, options={})
    name = name.to_s
    
    @order.push name unless @order.include?(name)
    @items[name] = Dormouse::Menu::Item.new(name, manifest, options)
    
    order!
    
    self
  end
  
private
  
  def order!
    @items.each do |name, item|
      @order.delete(name)
      
      case 
      when hook = item.order_options[:before]
        idx = @order.index(hook.to_s) || @order.size
        @order.insert(idx, name)
      when hook = item.order_options[:after]
        idx = @order.index(hook.to_s) || @order.size
        @order.insert(idx, name)
      when item.order_options[:top]
        @order.unshift(name)
      when item.order_options[:bottom]
        @order.push(name)
      else
        @order.push(name)
      end
    end
  end
  
end

class Dormouse::Menu::Item
  
  def initialize(name, manifest, options={})
    @name, @manifest, @options = name, manifest, options
    
    @order_options = @options.slice(:before, :after, :top, :bottom)
    @options.except!(:before, :after, :top, :bottom)
  end
  
  attr_reader :name, :manifest, :options, :order_options, :url
  
  def url
    @manifest.urls.index
  end
  
end

module Dormouse
  
  def self.menu
    @menu ||= Dormouse::Menu.new
  end
  
end