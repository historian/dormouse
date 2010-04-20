class Dormouse::Tab
  
  def initialize(manifest, property)
    @manifest, @property = manifest, property
  end
  
  attr_reader :manifest, :property
  
  def name
    @name ||= @property.resource.manifest.names.human(:plural => true)
  end
  
  def url_for_object(object)
    @suffix ||= @property.resource.to_s.split('::').last.tableize
    "#{manifest.object_url(object)}/#{@suffix}"
  end
  
end