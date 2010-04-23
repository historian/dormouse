# @author Simon Menke
class Dormouse::Tab
  
  def initialize(manifest, property)
    @manifest, @property = manifest, property
  end
  
  attr_reader :manifest, :property
  
  def name
    @name ||= @property.resource.manifest.names.human(:plural => true, :short => true)
  end
  
  def url_for_object(object)
    property.urls.index(object)
  end
  
end

# @author Simon Menke
class Dormouse::Tabs < Array
  
  def initialize(manifest)
    @manifest = manifest
  end
  
  def reset!
    clear
    
    @manifest.each do |property|
      next if property.hidden
      next unless [:has_many, :has_and_belongs_to_many].include? property.type
      next if property.options[:inline]
      self << Dormouse::Tab.new(@manifest, property)
    end
    
    self
  end
  
end