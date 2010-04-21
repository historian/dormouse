class Dormouse::Property
  
  def initialize(manifest, column_or_association)
    if ActiveRecord::Reflection::MacroReflection === column_or_association
      @type     = column_or_association.macro
      @resource = column_or_association.klass
    else
      @type     = column_or_association.type
    end
    @name     = column_or_association.name.to_sym
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
    @label   = @name.to_s.humanize     if @label.nil?
    @options = @options.merge(options)
  end
  
  def plural?
    [:has_many, :has_and_belongs_to_many].include? @type
  end
  
  def names
    @names ||= Dormouse::Names.new(self)
  end
  
  def urls
    @urls ||= Dormouse::Urls.new(self)
  end
  
end