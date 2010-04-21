# @author Simon Menke
class Dormouse::Property
  
  def initialize(manifest, target)
    @target   = target
    @options  = {}
    @manifest = manifest
    
    populate
  end
  
  attr_reader :name, :type, :options, :resource, :names, :urls, :manifest, :table
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
  
  def column?
    !reflection?
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
  
  def name(options={})
    @name ||= @target.name.to_sym
    if options[:table]
      "#{table}.#{@name}"
    else
      @name
    end
  end
  
  def table
    if column?
      @table_name ||= @manifest.resource.table_name
    else
      nil
    end
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