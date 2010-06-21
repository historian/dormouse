module Dormouse::Extentions::Menu

  module DSL

    # Set a menu item for this resource
    # @return [Dormouse::DSL] self
    def menu(name, options={})
      Dormouse.menu.register(name, @manifest, options)
      self
    end

    Dormouse::DSL.send :include, self
  end

  module Top

    # Global accessor for the menu
    def menu
      @menu ||= List.new
    end

    Dormouse.extend self
  end

  class List < Dormouse::OrderedHash

    def register(name, manifest, options={})
      name = name.to_s

      self[name] = Item.new(name, manifest, options)

      self
    end

  end

  class Item

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

end