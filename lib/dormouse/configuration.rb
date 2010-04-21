module Dormouse
  
  DEFAULT_OPTIONS = {
    :style                 => 'dormouse',
    :controller_superclass => 'ApplicationController'
  }.freeze
  
  def self.options
    @options ||= DEFAULT_OPTIONS.dup
  end
  
end