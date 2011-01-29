# @author Simon Menke
module Dormouse

  def self.manifests
    Rails.application.config.dormouse.resources.collect do |name|
      name.constantize.manifest
    end
  end

end