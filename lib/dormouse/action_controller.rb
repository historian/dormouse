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
    respond_to do |format|
      format.html { html_index }
      format.json { json_index }
    end
  end
  
  def show
    respond_to do |format|
      format.html { html_show }
      format.json { json_show }
    end
  end
  
  def new
    respond_to do |format|
      format.html { html_new }
    end
  end
  
  def edit
    respond_to do |format|
      format.html { html_edit }
    end
  end
  
  def create
    respond_to do |format|
      format.html { html_create }
      format.json { json_create }
    end
  end
  
  def update
    respond_to do |format|
      format.html { html_update }
      format.json { json_update }
    end
  end
  
  def destroy
    respond_to do |format|
      format.html { html_destroy }
      format.json { json_destroy }
    end
  end
  
protected
  
  def html_index
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
  
  def json_index
    @collection_count, @collection = *lookup_collection
    render :json => { :collection => @collection, :count => @collection_count }
  end
  
  def html_show
    @object = manifest.resource.find(params[:id])
    
    if request.xhr?
      render :template => "#{@manifest.style}/views/form",
             :layout   => false
    else
      render :template => "#{@manifest.style}/views/form",
             :layout   => "#{@manifest.style}/layouts/application"
    end
  end
  
  def json_show
    @object = manifest.resource.find(params[:id])
    render :json => @object
  end
  
  def html_new
    if @parent
      @object = @parent.__send__(@parent_association).build
    else
      @object = @manifest.resource.new
    end
    
    if request.xhr?
      render :template => "#{@manifest.style}/views/form",
             :layout   => false
    else
      render :template => "#{@manifest.style}/views/form",
             :layout   => "#{@manifest.style}/layouts/application"
    end
  end
  
  def html_edit
    @object = manifest.resource.find(params[:id])
    
    if request.xhr?
      render :template => "#{@manifest.style}/views/form",
             :layout   => false
    else
      render :template => "#{@manifest.style}/views/form",
             :layout   => "#{@manifest.style}/layouts/application"
    end
  end
  
  def html_create
    attrs = params[@manifest.names.param]
    
    if @parent
      @object = @parent.__send__(@parent_association).create!(attrs)
    else
      @object = @manifest.resource.create!(attrs)
    end
    
    redirect_to @manifest.urls.index(@parent)
    
  rescue ActiveRecord::RecordInvalid => e
    @object = e.record
    
    if request.xhr?
      render :template => "#{@manifest.style}/views/form",
             :layout   => false
    else
      render :template => "#{@manifest.style}/views/form",
             :layout   => "#{@manifest.style}/layouts/application"
    end
  end
  
  def json_create
    if collection = params[@manifest.names.params]
      objects = []
      
      @manifest.resource.transaction do
        collection.each do |attrs|
          
          if @parent
            objects << @parent.__send__(@parent_association).create!(attrs)
          else
            objects << @manifest.resource.create!(attrs)
          end
          
        end
      end
      
      render :json => objects
      
    elsif attrs = params[@manifest.names.param]
      
      if @parent
        object = @parent.__send__(@parent_association).create!(attrs)
      else
        object = @manifest.resource.create!(attrs)
      end
      
      render :json => object
      
    end
  rescue ActiveRecord::RecordInvalid => e
    render :json => e.record.errors
  end
  
  def html_update
    attrs = params[@manifest.names.param]
    
    @object = @manifest.resource.find(params[:id]).update_attributes!(attrs)
    
    redirect_to @manifest.urls.index
    
  rescue ActiveRecord::RecordInvalid => e
    @object = e.record
    
    if request.xhr?
      render :template => "#{@manifest.style}/views/form",
             :layout   => false
    else
      render :template => "#{@manifest.style}/views/form",
             :layout   => "#{@manifest.style}/layouts/application"
    end
  end
  
  def json_update
    if collection = params[@manifest.names.params]
      objects = @manifest.resource.find(collection.keys)
      
      @manifest.resource.transaction do
        objects.each do |object|
          
          object.update_attributes! collection[object.id.to_s]
          
        end
      end
      
      render :json => objects
      
    elsif attrs = params[@manifest.names.param]
      object = @manifest.resource.find(params[:id])
      object.update_attributes! attrs
      render :json => object
      
    end
  rescue ActiveRecord::RecordInvalid => e
    render :json => e.record.errors
  end
  
  def html_destroy
    @manifest.resource.find(params[:id]).destroy
    
    redirect_to @manifest.urls.index
    
  rescue ActiveRecord::RecordNotFound => e
    redirect_to @manifest.urls.index
  end
  
  def json_destroy
    if collection = params[@manifest.names.param_ids]
      objects = @manifest.resource.find(collection)
      
      @manifest.resource.transaction do
        objects.each do |object|
          
          object.destroy
          
        end
      end
      
      render :json => objects
      
    elsif id = params[:id]
      object = @manifest.resource.find(id)
      object.destroy
      render :json => object
      
    end
  rescue ActiveRecord::RecordInvalid => e
    render :json => e.record.errors
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
    
    if query = params[:q] and !query.blank?
      collection = collection.dormouse_search(manifest, query)
      order = manifest[:_primary].name(:table => true)
    end
    
    if letter = params[:l] and !letter.blank?
      collection = collection.dormouse_search(manifest, letter[0,1])
      order = manifest[:_primary].name(:table => true)
    end
    
    if filter = params[:f] and filter = manifest.filters[filters.to_sym]
      collection = collection.dormouse_filter(manifest, filter)
      order = manifest[:_primary].name(:table => true)
    end
    
    count = collection.count
    
    if page = params[:p] and !page.blank?
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