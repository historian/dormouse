# @author Simon Menke
module Dormouse

  def self.manifests
    resources.map do |name|
      name.constantize.manifest
    end
  end

  def self.resources
    Rails.application.config.dormouse.resources
  end

  def self.style
    Rails.application.config.dormouse.style
  end

  def self.default_namespace
    Rails.application.config.dormouse.default_namespace
  end

  def self.extentions
    Rails.application.config.dormouse.extentions
  end

end