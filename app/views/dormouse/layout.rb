module Dormouse::Layout

  def acceptable_collection_types
    %w( list )
  end
  
  def main_menu_items
    manifests_count = Dormouse.manifests.size
    Dormouse.manifests.each_with_index do |manifest, idx|
      next if manifest.owner
      
      url     = manifest.urls.index
      active  = request.path.starts_with?(url)
      first   = idx == 0
      last    = idx == (manifests_count - 1)
      
      yield(manifest, url, active, first, last)
    end
  end
  
  def classes(classes)
    classes.inject([]) do |m, (klass, active)|
      m << klass.to_s if active
      m
    end.compact.join(' ')
  end

end