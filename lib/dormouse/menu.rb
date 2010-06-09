# @author Simon Menke
class Dormouse::Menu < Dormouse::OrderedHash

  def register(name, manifest, options={})
    name = name.to_s

    self[name] = Dormouse::Menu::Item.new(name, manifest, options)

    self
  end

end

class Dormouse::Menu::Item

  def initialize(name, manifest, options={})
    @name, @manifest, @options = name, manifest, options

    @order_options = @options.slice(:before, :after, :top, :bottom)
    @options.except!(:before, :after, :top, :bottom)
  end

  attr_reader :name, :manifest, :options, :order_options, :url

  def url
    @manifest.urls.index
  end

end

module Dormouse

  def self.menu
    @menu ||= Dormouse::Menu.new
  end

end