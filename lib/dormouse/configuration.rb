# @author Simon Menke
module Dormouse

  DEFAULT_OPTIONS = {
    :style                 => 'dormouse',
    :controller_superclass => 'ApplicationController',
    :extensions            => %w(
      Dormouse::Extensions::Paperclip
      Dormouse::Extensions::LalalaAssets ),
    :cms_name              => 'Administration',
    :resources             => [],
    :default_namespace     => nil
  }.freeze

  def self.options
    Rails.application.config.dormouse
  end

  def self.manifests
    @manifests ||= options[:resources].collect do |resource|
      resource.to_s.constantize.manifest
    end
  end

end