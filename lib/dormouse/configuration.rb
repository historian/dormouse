# @author Simon Menke
module Dormouse

  DEFAULT_OPTIONS = {
    :style                 => 'dormouse',
    :controller_superclass => 'ApplicationController',
    :extentions            => %w( Dormouse::Extentions::Globalize Dormouse::Extentions::Paperclip Dormouse::Extentions::LalalaAssets ),
    :cms_name              => 'Administration',
    :resources             => []
  }.freeze

  def self.options
    @options ||= DEFAULT_OPTIONS.dup
  end

end