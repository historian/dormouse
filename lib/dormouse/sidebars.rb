class Dormouse::Sidebar < Struct.new(:type, :options)

  extend ActiveSupport::Memoizable

  attr_reader :order_options

  def populate(options={})
    @order_options = options.slice(:after, :before, :top, :bottom)
    options = options.except(:after, :before, :top, :bottom)

    self.options = self.options.merge(options)
  end

  def render_for_action?(action)
    action = action.to_sym

    if self.options[:except] and self.options[:except].include?(action)
      return false
    end

    if self.options[:only] and !self.options[:only].include?(action)
      return false
    end

    return true
  end
  memoize :render_for_action?

end

class Dormouse::Sidebars < Dormouse::OrderedHash

  def initialize(manifest)
    @manifest = manifest
  end

  def render(action)
    self.each do |sidebar|
      next unless sidebar.render_for_action?(action)

      partial = "#{@manifest.style}/sidebars/#{sidebar.type}"

      yield(:partial => partial)
    end
  end

end