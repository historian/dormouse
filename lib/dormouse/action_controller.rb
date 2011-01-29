# @author Simon Menke
module Dormouse::ActionController

  module Builder

    def self.build(manifest, map)
      build_routes(manifest, map)
    end

    def self.build_controller(manifest)
      superclass = Rails.application.config.dormouse.controller_superclass.constantize
      controller = Class.new(superclass)
      manifest.resource.const_set('ResourcesController', controller)
      controller.instance_variable_set '@manifest', manifest
      controller.send :include, Dormouse::ActionController
      controller
    end

    def self.build_routes(manifest, map)
      name       = manifest.names.identifier(:plural => true, :short => true)
      controller = manifest.names.controller_name
      ns         = manifest.namespace || manifest.names.controller_namespace
      ns         = ns.split('/')

      this = map

      ns.each do |part|
        this.instance_eval do
          namespace(part) { this = self }
        end
      end

      this.instance_eval do
        resources name.to_sym, :controller => controller do

          collection do
            post   :create_many
            put    :update_many
            delete :destroy_many
          end

          manifest.each do |property|
            Dormouse::ActionController::Builder.build_sub_routes(
              manifest, property, self)
          end

        end
      end
    end

    def self.build_sub_routes(parent, property, map)
      return unless property.plural? and !property.options[:inline]
      name       = property.names.identifier(:plural => true, :short => true)
      controller = property.names.controller_name

      options = { :controller => controller, :only => [:index, :new, :create] }

      map.instance_eval do
        scope :dormouse_association  => property.names.id,
              :dormouse_parent_class => parent.resource.to_s do
          resources name.to_sym, options do

            collection do
              post :create_many
            end

          end
        end
      end
    end

  end

  extend ActiveSupport::Concern

  included do
    include Dormouse::BaseController
    helper_method :manifest, :save_url
    before_filter :assign_manifest
    before_filter :lookup_parent, :only => [:index, :new, :create]
    respond_to    :html, :xml, :json
    style_helper = ("#{manifest.style.classify}Helper".constantize rescue nil)
    if style_helper
      helper style_helper
      style_helper.prepare
    end
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
      @object = @parent.__send__(@parent_association).build(attrs)
    else
      @object = @manifest.resource.new(attrs)
    end

    if @object.save
      redirect_to manifest.urls.show(@object)
    else
      render :template => "#{@manifest.style}/views/form"
    end
  end

  def create_many
    attrs = params[@manifest.names.params]

    @objects = attrs.collect do |attrs|
      if @parent
        @parent.__send__(@parent_association).build(attrs)
      else
        @manifest.resource.new(attrs)
      end
    end

    if @objects.all? { |object| object.valid? }
      model.resource.transaction do
        @objects.collect { |object| object.save! }
      end

      redirect_to manifest.urls.index(@parent)
    else
      redirect_to :back
    end
  end

  def update
    attrs = params[@manifest.names.param]

    @object = @manifest.resource.find(params[:id])

    if @object.update_attributes(attrs)
      redirect_to manifest.urls.show(@object)
    else
      render :template => "#{@manifest.style}/views/form"
    end
  end

  def update_many
    attrs = params[@manifest.names.params]

    @objects = manifest.resource.find(attrs.keys)

    model.resource.transaction do
      @objects.each do |object|
        object.update_attributes! attrs[object.id.to_s]
      end
    end

    respond_with(@objects, :location => :back)

  rescue ActiveRecord::RecordInvalid => e
    @object = e.record

    respond_with(@objects) do |format|
      format.html { redirect_to :back }
    end
  end

  def destroy
    @object = @manifest.resource.find(params[:id])
    @object.destroy

    respond_with(@object)
  end

  def destroy_many
    @objects = @manifest.resource.find(params[@manifest.names.params])

    model.resource.transaction do
      @objects.each { |object| object.destroy }
    end

    respond_with(@objects, :location => :back)
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
    if  klass = params[:dormouse_parent_class] \
    and assoc = params[:dormouse_association]
      klass = klass.constantize
      @parent_manifest    = klass.manifest
      @parent_association = assoc

      param   = @parent_manifest.names.param_id
      @parent = @parent_manifest.resource.find(params[param])
    end
  end

  def lookup_collection
    collection = (@parent ? @parent.__send__(@parent_association) :
                            manifest.resource)

    unless params[:'page-size'].blank?
      cookies[:page_size] = params[:'page-size']
    end

    page_size = cookies[:page_size] || 25
    page_size = page_size.to_i unless page_size == 'all'

    if manifest[:position]
      order = "#{manifest[:position].names.column} #{manifest[:created_at].names.column}"
    else
      order = "#{manifest[:created_at].names.column}"
    end
    count = 0

    if query = params[:q] and !query.blank?
      collection = collection.dormouse_search(manifest, query)
      order = manifest[:_primary].names.column
    end

    if letter = params[:l] and !letter.blank?
      collection = collection.dormouse_search(manifest, letter[0,1])
      order = manifest[:_primary].names.column
    end

    if filter = params[:f] and filter = manifest.filters[filters.to_sym]
      collection = collection.dormouse_filter(manifest, filter)
      order = manifest[:_primary].names.column
    end

    count = collection.count

    if page = params[:p] and !page.blank?
      collection = collection.dormouse_paginate(manifest, page, page_size)
      order = manifest[:_primary].names.column
    else
      collection = collection.dormouse_paginate(manifest, 1, page_size)
    end

    order = params[:o] unless params[:o].blank?
    collection = collection.dormouse_order(manifest, order)

    [count, collection.all]
  end

end

module Dormouse::ActionController::ClassMethods

  attr_accessor :manifest

end

module Dormouse::BaseController
  extend ActiveSupport::Concern

  included do
    around_filter :activate_controller
  end

private

  def activate_controller
    Thread.current[:'dormouse.current_controller'] = self
    yield
  ensure
    Thread.current[:'dormouse.current_controller'] = nil
  end

end
