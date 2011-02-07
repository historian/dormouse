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
    @options ||= DEFAULT_OPTIONS.dup
  end

  def self.manifests
    @manifests ||= options[:resources].collect do |name|
      name.constantize.manifest
    end
  end

end