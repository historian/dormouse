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
    controller = manifest.controller_class.to_s.sub(/Controller$/, '').sub(%r{^#{namespaces.join('::')}([:]{2})?}, '').underscore
    
    namespaces.inject(map) do |map, namespace|
      map.namespace(namespace.underscore) { |map| map }
      map
    end
    
    options = { :controller => controller, :collection => { :update => :put, :destroy => :delete } }
    map.resources name.to_sym, options do |subresource|
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
    controller = controller.to_s.sub(/Controller$/, '').sub(%r{^#{namespaces.join('::')}([:]{2})?}, '').underscore
    
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
    manifest.render_collection(self, lookup_collection)
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
    singular_param = manifest.resource.to_s.gsub('::', '_').underscore
    plural_param   = singular_param.pluralize
    
    collection = params[plural_param] || []
    collection.push params[singular_param] if params[singular_param]
    
    manifest.resource.transaction do
      collection.each do |attrs|
        object = (@parent ? @parent.__send__(@parent_association).build(attrs) :
                            manifest.resource.new(attrs))
        object.save!
      end
    end
    
    redirect_to manifest.collection_url
  rescue ActiveRecord::RecordInvalid => e
    manifest.render_form(self, e.record)
  end
  
  def update
    singular_param = manifest.resource.to_s.gsub('::', '_').underscore
    plural_param   = singular_param.pluralize
    
    collection = params[plural_param] || {}
    collection[params[:id]] = params[singular_param] if params[singular_param]
    
    manifest.resource.transaction do
      collection.each do |id, attrs|
        manifest.resource.find(id).update_attributes! attrs
      end
    end
    
    redirect_to manifest.collection_url
  rescue ActiveRecord::RecordInvalid => e
    manifest.render_form(self, e.record)
  rescue ActiveRecord::RecordNotFound => e
    redirect_to manifest.collection_url
  end
  
  def destroy
    singular_param = manifest.resource.to_s.gsub('::', '_').underscore
    plural_param   = "#{singular_param}_ids".pluralize
    
    ids = params[plural_param] || []
    ids.push(params[:id]) if params[:id]
    
    manifest.resource.transaction do
      ids.each do |id|
        manifest.resource.find(id).destroy
      end
    end
    
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
  
  def lookup_collection
    collection = (@parent ? @parent.__send__(@parent_association) :
                            manifest.resource)
    
    order = "-updated_at"
    
    if query = params[:q]
      collection = collection.dormouse_search(manifest, query)
      order = manifest.primary_name_column
    end
    
    if letter = params[:l]
      collection = collection.dormouse_search(manifest, letter[0,1])
      order = manifest.primary_name_column
    end
    
    if filter = params[:f] and filter = manifest.filters[filters.to_sym]
      collection = collection.dormouse_filter(manifest, filter)
      order = manifest.primary_name_column
    end
    
    if page = params[:p]
      collection = collection.dormouse_paginate(manifest, page)
      order = manifest.primary_name_column
    else
      collection = collection.dormouse_paginate(manifest, 1)
    end
    
    order = params[:o] unless params[:o].blank?
    collection = collection.dormouse_order(manifest, order)
    
    collection.all
  end
  
end

module Dormouse::ActionController::Meta
  
  attr_accessor :manifest
  attr_reader :potential_parents
  
  def potential_parents
    @potential_parents ||= {}
  end
  
end