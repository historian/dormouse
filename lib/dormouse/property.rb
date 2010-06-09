# @author Simon Menke
class Dormouse::Property

  def initialize(manifest, target, table_name=nil)
    if Symbol === target or String === target
      @name   = target.to_sym
      @type   = :string
      @hidden = true
    else
      @target = target
    end
    @options       = {}
    @order_options = {}
    @manifest      = manifest
    @table_name    = table_name

    populate
  end

  attr_reader :name, :type, :options, :order_options, :resource, :names, :urls, :manifest, :table
  attr_accessor :hidden
  attr_accessor :label

  def populate(options={})
    @hidden  = options.delete(:hidden) if options.key?(:hidden)
    @label   = options.delete(:label)  if options.key?(:label)
    @type    = options.delete(:type)   if options.key?(:type)

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

  def type
    @type ||= begin
      if reflection?
        @target.macro
      else
        @target.type
      end
    end
  end

  def label
    if @label.nil?
      @label = self.names.human(:short => true, :plural => plural?)
    end
    @label
  end

  def name(options={})
    @name ||= @target.name.to_sym
    if options[:ids]
      "#{@name.to_s.singularize}_ids".to_sym
    elsif options[:table]
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