module Dormouse::ActionController
  
  def self.build(manifest, map)
    build_routes(manifest, map)
  end
  
  def self.build_controller(manifest)
    controller = eval("class ::#{manifest.resource}::ResourcesController < ::#{manifest.controller_superclass} ; self ; end ")
    controller.extend Meta
    controller.send :include, Actions
    controller.manifest = manifest
    controller
  end
  
  def self.build_routes(manifest, map)
    name       = manifest.names.identifier(:plural => true, :short => true)
    namespaces = manifest.names.controller_namespace.split('/')
    controller = manifest.names.controller_name
    
    namespaces.inject(map) do |map, namespace|
      map.namespace(namespace) { |map| map }
      map
    end
    
    options = { :controller => controller, :collection => { :update => :put, :destroy => :delete } }
    map.resources name.to_sym, options do |subresource|
      manifest.each do |property|
        
        next unless property.resource
        build_sub_routes(manifest, property, subresource)
        
      end
    end
  end
  
  def self.build_sub_routes(parent, property, map)
    return unless property.type == :has_many and !property.options[:inline]
    
    manifest   = property.resource.manifest
    controller = manifest.controller_class
    controller.potential_parents[property.name.to_sym] = parent
    
    name       = property.names.identifier(:plural => true, :short => true)
    controller = property.names.controller_name
    
    options = { :controller => controller, :only => [:index, :new, :create] }
    map.resources name.to_sym, options do |map|
      manifest.each do |property|
        
        next unless property.resource
        build_sub_routes(manifest, property, map)
        
      end
    end
  end
  
end

module Dormouse::ActionController::Actions
  
  def self.included(base)
    base.class_eval do
      helper_method :manifest
      before_filter :lookup_parent, :only => [:index, :new, :create]
    end
  end
  
  def index
    collection = (@parent ? @parent.__send__(@parent_association).all : nil)
    manifest.render_collection(self, collection)
  end
  
  def show
    manifest.render_form(self)
  end
  
  def new
    object = (@parent ? @parent.__send__(@parent_association).build : nil)
    manifest.render_form(self, object)
  end
  
  def edit
    manifest.render_form(self)
  end
  
  def create
    singular_param = manifest.names.param
    plural_param   = manifest.names.params
    
    collection = params[plural_param] || []
    collection.push params[singular_param] if params[singular_param]
    
    manifest.resource.transaction do
      collection.each do |attrs|
        object = (@parent ? @parent.__send__(@parent_association).build(attrs) :
                            manifest.resource.new(attrs))
        object.save!
      end
    end
    
    redirect_to manifest.urls.index(@parent)
  rescue ActiveRecord::RecordInvalid => e
    manifest.render_form(self, e.record)
  end
  
  def update
    singular_param = manifest.names.param
    plural_param   = manifest.names.params
    
    collection = params[plural_param] || {}
    collection[params[:id]] = params[singular_param] if params[singular_param]
    
    manifest.resource.transaction do
      collection.each do |id, attrs|
        manifest.resource.find(id).update_attributes! attrs
      end
    end
    
    redirect_to manifest.urls.index
  rescue ActiveRecord::RecordInvalid => e
    manifest.render_form(self, e.record)
  rescue ActiveRecord::RecordNotFound => e
    redirect_to manifest.urls.index
  end
  
  def destroy
    plural_param   = manifest.names.param_ids
    
    ids = params[plural_param] || []
    ids.push(params[:id]) if params[:id]
    
    manifest.resource.transaction do
      ids.each do |id|
        manifest.resource.find(id).destroy
      end
    end
    
    redirect_to manifest.urls.index
  rescue ActiveRecord::RecordNotFound => e
    redirect_to manifest.urls.index
  end
  
private
  
  def manifest
    self.class.manifest
  end
  
  def lookup_parent
    self.class.potential_parents.each do |association, manifest|
      param = manifest.names.param_id
      if params[param]
        @parent_manifest = manifest
        @parent = manifest.resource.find(params[param])
        @parent_association = association
        break
      end
    end
  end
  
end

module Dormouse::ActionController::Meta
  
  attr_accessor :manifest
  attr_reader :potential_parents
  
  def potential_parents
    @potential_parents ||= {}
  end
  
end