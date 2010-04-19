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
    namespaces = manifest.resource.to_s.split('::')
    name       = namespaces.last.tableize
    namespaces = namespaces[0..-2]
    controller = manifest.controller_class.to_s.sub(/Controller$/, '').sub(%r{^#{namespaces.join('::')}([:]{2})?}, '')
    
    namespaces.inject(map) do |map, namespace|
      map.namespace(namespace.underscore) { |map| map }
      map
    end
    
    map.resources name.to_sym, :controller => controller do |subresource|
      manifest.each do |property|
        
        next unless property.resource
        build_sub_routes(manifest, property, property.resource.manifest, subresource)
        
      end
    end
  end
  
  def self.build_sub_routes(parent, property, manifest, map)
    return unless property.type == :has_many and !property.options[:inline]
    controller = manifest.controller_class
    controller.potential_parents[property.name.to_sym] = parent
    
    namespaces = manifest.resource.to_s.split('::')
    namespaces = namespaces[0..-2]
    controller = controller.to_s.sub(/Controller$/, '').sub(%r{^#{namespaces.join('::')}([:]{2})?}, '')
    
    options = { :controller => controller, :only => [:index, :new, :create] }
    map.resources property.name.to_sym, options do |map|
      manifest.each do |property|
        
        next unless property.resource
        build_sub_routes(manifest, property, property.resource.manifest, map)
        
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
    attrs = params[manifest.resource.to_s.gsub('::', '_').underscore]
    object = (@parent ? @parent.__send__(@parent_association).build(attrs) :
                        manifest.resource.new(attrs))
    object.save!
    redirect_to manifest.collection_url
  rescue ActiveRecord::RecordInvalid => e
    manifest.render_form(self, e.record)
  end
  
  def update
    attrs = params[manifest.resource.to_s.gsub('::', '_').underscore]
    manifest.resource.find(params[:id]).update_attributes! attrs
    redirect_to manifest.collection_url
  rescue ActiveRecord::RecordInvalid => e
    manifest.render_form(self, e.record)
  rescue ActiveRecord::RecordNotFound => e
    redirect_to manifest.collection_url
  end
  
  def destroy
    manifest.resource.find(params[:id]).destroy
    redirect_to manifest.collection_url
  rescue ActiveRecord::RecordNotFound => e
    redirect_to manifest.collection_url
  end
  
private
  
  def manifest
    self.class.manifest
  end
  
  def lookup_parent
    self.class.potential_parents.each do |association, manifest|
      param = manifest.resource.to_s.split('::').last.underscore + '_id'
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