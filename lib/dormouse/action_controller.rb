# @author Simon Menke
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
    namespace  = manifest.names.controller_namespace
    controller = manifest.names.controller_name
    
    options = { :controller => controller, :collection => { :update => :put, :destroy => :delete }, :path_prefix => "/#{namespace}" }
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
    map.resources name.to_sym, options
  end
  
end

module Dormouse::ActionController::Actions
  
  def self.included(base)
    base.class_eval do
      helper_method :manifest, :save_url
      before_filter :assign_manifest
      before_filter :lookup_parent, :only => [:index, :new, :create]
    end
  end
  
  def index
    @collection_count, @collection = *lookup_collection
    if request.xhr?
      render \
        :template => "#{@manifest.style}/views/#{@manifest.collection_type}",
        :layout   => false
    else
      render \
        :template => "#{@manifest.style}/views/#{@manifest.collection_type}",
        :layout   => "#{@manifest.style}/layouts/application"
    end
  end
  
  def show
    @manifest.render_form(self)
  end
  
  def new
    object = (@parent ? @parent.__send__(@parent_association).build : nil)
    @manifest.render_form(self, object)
  end
  
  def edit
    @manifest.render_form(self)
  end
  
  def create
    names = @manifest.names
    singular_param = names.param
    plural_param   = names.params
    
    collection = params[plural_param] || []
    collection.push params[singular_param] if params[singular_param]
    
    @manifest.resource.transaction do
      collection.each do |attrs|
        object = (@parent ? @parent.__send__(@parent_association).build(attrs) :
                            @manifest.resource.new(attrs))
        object.save!
      end
    end
    
    redirect_to @manifest.urls.index(@parent)
  rescue ActiveRecord::RecordInvalid => e
    @manifest.render_form(self, e.record)
  end
  
  def update
    names = @manifest.names
    singular_param = names.param
    plural_param   = names.params
    
    collection = params[plural_param] || {}
    collection[params[:id]] = params[singular_param] if params[singular_param]
    
    @manifest.resource.transaction do
      collection.each do |id, attrs|
        @manifest.resource.find(id).update_attributes! attrs
      end
    end
    
    redirect_to @manifest.urls.index
  rescue ActiveRecord::RecordInvalid => e
    @manifest.render_form(self, e.record)
  rescue ActiveRecord::RecordNotFound => e
    redirect_to @manifest.urls.index
  end
  
  def destroy
    plural_param   = @manifest.names.param_ids
    
    ids = params[plural_param] || []
    ids.push(params[:id]) if params[:id]
    
    @manifest.resource.transaction do
      ids.each do |id|
        @manifest.resource.find(id).destroy
      end
    end
    
    redirect_to @manifest.urls.index
  rescue ActiveRecord::RecordNotFound => e
    redirect_to @manifest.urls.index
  end
  
private
  
  def save_url
    if @object.new_record?
      manifest.urls.create(@parent)
    else
      manifest.urls.update(@object)
    end
  end
  
  def assign_manifest
    @manifest = self.class.manifest
  end
  
  def manifest
    @manifest
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
  
  def lookup_collection
    collection = (@parent ? @parent.__send__(@parent_association) :
                            manifest.resource)
    
    order = "-#{manifest[:updated_at].name(:table => true)}"
    count = 0
    
    if query = params[:q]
      collection = collection.dormouse_search(manifest, query)
      order = manifest[:_primary].name(:table => true)
    end
    
    if letter = params[:l]
      collection = collection.dormouse_search(manifest, letter[0,1])
      order = manifest[:_primary].name(:table => true)
    end
    
    if filter = params[:f] and filter = manifest.filters[filters.to_sym]
      collection = collection.dormouse_filter(manifest, filter)
      order = manifest[:_primary].name(:table => true)
    end
    
    count = collection.count
    
    if page = params[:p]
      collection = collection.dormouse_paginate(manifest, page)
      order = manifest[:_primary].name(:table => true)
    else
      collection = collection.dormouse_paginate(manifest, 1)
    end
    
    order = params[:o] unless params[:o].blank?
    collection = collection.dormouse_order(manifest, order)
    
    [count, collection.all]
  end
  
end

module Dormouse::ActionController::Meta
  
  attr_accessor :manifest
  attr_reader :potential_parents
  
  def potential_parents
    @potential_parents ||= {}
  end
  
end