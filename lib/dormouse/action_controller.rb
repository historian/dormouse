# @author Simon Menke
module Dormouse::ActionController

  def self.build(manifest, map)
    build_routes(manifest, map)
  end

  def self.build_controller(manifest)
    controller = Class.new(manifest.controller_superclass)
    manifest.resource.const_set('ResourcesController', controller)
    controller.instance_variable_set '@manifest', manifest
    controller.send :include, Actions
    controller
  end

  def self.build_routes(manifest, map)
    name       = manifest.names.identifier(:plural => true, :short => true)
    namespace  = manifest.names.controller_namespace
    controller = manifest.names.controller_name

    options = { :controller => controller, :collection => { :update => :put, :destroy => :delete }, :path_prefix => "/#{namespace}" }
    map.resources name.to_sym, options do |subresource|
      manifest.each do |property|

        build_sub_routes(manifest, property, subresource)

      end
    end
  end

  def self.build_sub_routes(parent, property, map)
    return unless property.plural? and !property.options[:inline]

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

  extend ActiveSupport::Concern

  included do
    helper_method :manifest, :save_url
    before_filter :assign_manifest
    before_filter :lookup_parent, :only => [:index, :new, :create]
    respond_to    :html, :xml, :json
    layout "#{manifest.style}/layouts/application"
  end

  def index
    @collection_count, @collection = *lookup_collection

    respond_with(@collection) do |format|
      format.html { render :template => "#{@manifest.style}/views/#{@manifest.collection_type}" }
    end
  end

  def show
    @object = manifest.resource.find(params[:id])

    respond_with(@object) do |format|
      format.html { render :template => "#{@manifest.style}/views/form" }
    end
  end

  def new
    if @parent
      @object = @parent.__send__(@parent_association).build
    else
      @object = @manifest.resource.new
    end

    respond_with(@object) do |format|
      format.html { render :template => "#{@manifest.style}/views/form" }
    end
  end

  def edit
    @object = manifest.resource.find(params[:id])

    respond_with(@object) do |format|
      format.html { render :template => "#{@manifest.style}/views/form" }
    end
  end

  def create
    attrs = params[@manifest.names.param]

    if @parent
      @object = @parent.__send__(@parent_association).create!(attrs)
    else
      @object = @manifest.resource.create!(attrs)
    end

    respond_with(@object)

  rescue ActiveRecord::RecordInvalid => e
    @object = e.record

    respond_with(@object) do |format|
      format.html { render :template => "#{@manifest.style}/views/form" }
    end
  end

  def update
    attrs = params[@manifest.names.param]

    @object = @manifest.resource.find(params[:id]).update_attributes!(attrs)

    respond_with(@object)

  rescue ActiveRecord::RecordInvalid => e
    @object = e.record

    respond_with(@object) do |format|
      format.html { render :template => "#{@manifest.style}/views/form" }
    end
  end

  def destroy
    @object = @manifest.resource.find(params[:id])
    @object.destroy

    respond_with(@object)
  end

private

  def save_url
    if @object.new_record?
      if @parent
        @parent_manifest[@parent_association].urls.create(@parent)
      else
        manifest.urls.create(@parent)
      end
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

    if manifest[:position]
      order = "#{manifest[:position].name(:table => true)} #{manifest[:created_at].name(:table => true)}"
    else
      order = "#{manifest[:created_at].name(:table => true)}"
    end
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

module Dormouse::ActionController::Actions::ClassMethods

  attr_accessor :manifest
  attr_reader :potential_parents

  def potential_parents
    @potential_parents ||= {}
  end

end