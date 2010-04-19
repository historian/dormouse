module Dormouse::ActionController
  
  def self.build(manifest)
    build_routes(manifest)
  end
  
  def self.build_controller(manifest)
    controller = eval("class ::#{manifest.resource}::ResourcesController < ::#{manifest.controller_superclass} ; self ; end ")
    controller.extend Meta
    controller.send :include, Actions
    controller.manifest = manifest
    controller
  end
  
  def self.build_routes(manifest)
    name       = manifest.resource.to_s.split('::').last.tableize
    controller = manifest.controller_class.to_s.sub(/Controller$/, '')
    Dormouse::Application.routes.draw do |map|
      resources name.to_sym, :controller => controller
    end
  end
  
end

module Dormouse::ActionController::Actions
  
  def self.included(base)
    base.class_eval do
      helper_method :manifest
    end
  end
  
  def index
    manifest.render_list(self)
  end
  
  def new
    manifest.render_form(self)
  end
  
  def edit
    manifest.render_form(self)
  end
  
  def create
    attrs = params[manifest.resource.to_s.split('::').last.underscore]
    manifest.resource.create! attrs
    redirect_to manifest.resource
  rescue ActiveRecord::RecordInvalid => e
    manifest.render_form(self, e.record)
  end
  
  def update
    attrs = params[manifest.resource.to_s.split('::').last.underscore]
    manifest.resource.find(params[:id]).update_attributes! attrs
    redirect_to manifest.resource
  rescue ActiveRecord::RecordInvalid => e
    manifest.render_form(self, e.record)
  end
  
private
  
  def manifest
    self.class.manifest
  end
  
end

module Dormouse::ActionController::Meta
  
  attr_accessor :manifest
  
end