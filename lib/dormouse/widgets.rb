# @author Simon Menke
class Dormouse::Widgets < Array
  
  def initialize(manifest)
    @manifest = manifest
  end
  
  def reset!
    clear
    
    @manifest.each do |property|
      widget_klass = Dormouse::Widgets[property.type]
      self << widget_klass.new(@manifest, property) if widget_klass
    end
    
    self
  end
  
  class << self
    def [](name)
      (@widget_types ||= {})[name.to_sym]
    end
    
    def []=(name, klass)
      (@widget_types ||= {})[name.to_sym] = klass
    end
  end
  
  require 'dormouse/widgets/base'
  require 'dormouse/widgets/simple'
  
  require 'dormouse/widgets/string'
  require 'dormouse/widgets/text'
  require 'dormouse/widgets/date'
  require 'dormouse/widgets/time'
  require 'dormouse/widgets/datetime'
  require 'dormouse/widgets/boolean'
  require 'dormouse/widgets/integer'
  require 'dormouse/widgets/float'
  require 'dormouse/widgets/decimal'
  require 'dormouse/widgets/timestamp'
  
  require 'dormouse/widgets/has_many'
  require 'dormouse/widgets/belongs_to'
  
end