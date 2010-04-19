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
    
    populate
  end
  
  attr_reader :name, :type, :options, :resource
  attr_accessor :hidden
  attr_accessor :label
  
  def populate(options={})
    @hidden  = options.delete(:hidden) if options.key?(:hidden)
    @label   = options.delete(:label)  if options.key?(:label)
    @label   = @name.to_s.humanize     if @label.nil?
    @options = @options.merge(options)
  end
  
end