class Dormouse::OrderedHash < ActiveSupport::OrderedHash

  def sort!(&block)
    block ||= lambda { |value| value.order_options }

    ordered_keys = @keys.dup
    size = ordered_keys.size

    ordered_keys.sort! { |a,b| a.to_s <=> b.to_s }

    self.each do |key, value|
      options = block.call(value)

      case
      when other = options[:after]
        ordered_keys.delete(key)
        idx = ordered_keys.index(other.to_sym) || -1
        ordered_keys.insert(idx + 1, key)

      when other = options[:before]
        ordered_keys.delete(key)
        idx = ordered_keys.index(other.to_sym) || -1
        ordered_keys.insert(idx, key)

      when options[:top]
        ordered_keys.delete(key)
        ordered_keys.insert(0, key)

      when options[:bottom]
        ordered_keys.delete(key)
        ordered_keys.insert(-1, key)

      else
        ordered_keys.delete(key)
        ordered_keys.insert(-1, key)

      end
    end

    @keys = ordered_keys

    self
  end

end