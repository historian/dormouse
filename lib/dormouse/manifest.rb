class Dormouse::Manifest
  
  include Enumerable
  
  def initialize(resource)
    @resource   = resource
    @properties = {}
    @order      = []
    
    generate_default_properties
  end
  
  attr_reader :resource, :order
  attr_accessor :primary_name_column, :secondary_name_column
  attr_accessor :collection_url, :object_url
  attr_accessor :style
  
  def mount(map)
    Dormouse::ActionController.build(self, map)
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
    ApplicationController
  end
  
  def controller_class
    @controller_class ||= "#{resource}::ResourcesController".constantize
  end
  
  def style
    @style ||= 'dormouse'
  end
  
  def primary_name_column
    @primary_name_column ||= @properties[@order.first].name
  end
  
  def collection_url
    @collection_url ||= "/#{@resource.to_s.gsub('::', '/').underscore.pluralize}"
  end
  
  def object_url(object=nil)
    if object
      self.object_url.gsub(%r{[:]([^/]+)}) do
        object.__send__($1).to_s
      end
    else
      @object_url ||= "#{collection_url}/:id"
    end
  end
  
  def save_object_url(object=nil)
    if object
      if object.new_record?
        collection_url
      else
        object_url(object)
      end
    else
      @object_url ||= "#{collection_url}/:id"
    end
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