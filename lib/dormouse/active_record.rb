module Dormouse::ActiveRecord
  
  def self.included(base)
    base.extend Meta
  end
  
  def manifest
    self.class.manifest
  end
  
end

module Dormouse::ActiveRecord::Meta
  
  def manifest(&block)
    @manifest ||= Dormouse::Manifest.new(self)
    Dormouse::DSL.new(@manifest).instance_eval(&block) if block
    @manifest
  end
  
  def const_missing(name)
    if name == 'ResourcesController'
      Dormouse::ActionController.build_controller(manifest)
    else
      super
    end
  end
  
end

class ActiveRecord::Base
  include Dormouse::ActiveRecord
end