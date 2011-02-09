# @author Simon Menke
module Dormouse

  DEFAULT_OPTIONS = {
    :style                 => 'dormouse',
    :controller_superclass => 'ApplicationController',
    :extensions            => %w(
      Dormouse::Extensions::Paperclip
      Dormouse::Extensions::BlackbirdI18n
      Dormouse::Extensions::LalalaAssets ),
    :cms_name              => 'Administration',
    :resources             => [],
    :default_namespace     => nil
  }.freeze

  def self.options
    Rails.application.config.dormouse
  end

  def self.manifests
    @manifests ||= resources.collect do |resource|
      resource.to_s.constantize.manifest
    end
  end

  def self.resources
    options.resources
  end

  def self.style
    options.style
  end

  def self.default_namespace
    options.default_namespace
  end

  def self.extensions
    options.extensions
  end

end