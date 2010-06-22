# @author Simon Menke
class Dormouse::Property

  extend ActiveSupport::Memoizable

  def initialize(manifest, target, table_name=nil)
    @options       = {}
    @order_options = {}
    @manifest      = manifest
    @table_name    = table_name

    if Symbol === target or String === target
      # normal columns
      @name   = target.to_sym
      @type   = :string
      @hidden = true

      @names = Dormouse::Names.new(nil, @name, @table_name, false)

    else
      # assotiations and composites
      @target = target
      if plural?
        @names = Dormouse::Names.new(
          @target.klass, @target.name.to_s.singularize, @table_name, true)
      elsif reflection?
        @names = Dormouse::Names.new(
          @target.klass, @target.name, @table_name, false)
      else
        @names = Dormouse::Names.new(
          nil, @target.name, @table_name, false)
      end
    end

    populate
  end

  attr_reader :options, :order_options, :manifest
  attr_accessor :hidden
  attr_accessor :description

  def populate(options={})
    @description = options.delete(:description) if options.key?(:description)
    @hidden      = options.delete(:hidden)      if options.key?(:hidden)
    @label       = options.delete(:label)       if options.key?(:label)
    @type        = options.delete(:type)        if options.key?(:type)

    @order_options = options.slice(:after, :before, :top, :bottom)
    options = options.except(:after, :before, :top, :bottom)

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

  def plural?
    [:has_many, :has_and_belongs_to_many].include? self.type
  end

  def polymorphic?
    association? and @target.options[:polymorphic]
  end

  attr_reader :type
  def type
    @type ||= begin
      if reflection?
        @target.macro
      else
        @target.type
      end
    end
  end

  attr_accessor :label
  def label
    if @label.nil?
      @label = self.names.human(:short => true, :plural => plural?)
    end
    @label
  end

  attr_reader :table
  def table
    if column?
      @table_name ||= @manifest.resource.table_name
    else
      nil
    end
  end

  attr_reader :resource
  def resource
    @resource ||= begin
      if association? and !polymorphic?
        @target.klass
      else
        nil
      end
    end
  end

  attr_reader :names

  attr_reader :urls
  def urls
    if association?
      @urls ||= Dormouse::URLs.new(self.names, @manifest.names, @manifest.namespace)
    end
  end

end