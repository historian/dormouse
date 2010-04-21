class Dormouse::Property
  
  def initialize(manifest, target)
    @target   = target
    @options  = {}
    @manifest = manifest
    
    populate
  end
  
  attr_reader :name, :type, :options, :resource, :names, :urls, :manifest
  attr_accessor :hidden
  attr_accessor :label
  
  def populate(options={})
    @hidden  = options.delete(:hidden) if options.key?(:hidden)
    @label   = options.delete(:label)  if options.key?(:label)
    @label   = self.name.to_s.humanize if @label.nil?
    @options = @options.merge(options)
  end
  
  def reflection?
    ActiveRecord::Reflection::MacroReflection === @target
  end
  
  def association?
    ActiveRecord::Reflection::AssociationReflection === @target
  end
  
  def type
    @type ||= begin
      if reflection?
        @target.macro
      else
        @target.type
      end
    end
  end
  
  def name
    @name ||= @target.name.to_sym
  end
  
  def resource
    @resource ||= begin
      if association? and !polymorphic?
        @target.klass
      else
        nil
      end
    end
  end
  
  def plural?
    [:has_many, :has_and_belongs_to_many].include? @type
  end
  
  def polymorphic?
    association? and @target.options[:polymorphic]
  end
  
  def names
    @names ||= Dormouse::Names.new(self)
  end
  
  def urls
    @urls ||= Dormouse::Urls.new(self)
  end
  
end