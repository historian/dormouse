class Dormouse::Tab
  
  def initialize(manifest, property)
    @manifest, @property = manifest, property
  end
  
  attr_reader :manifest, :property
  
  def name
    @name ||= @property.resource.manifest.names.human(:plural => true)
  end
  
  def url_for_object(object)
    property.urls.index(object)
  end
  
end