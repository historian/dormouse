module Dormouse::Extensions::BlackbirdI18n

  def self.define(manifest)
    resource = manifest.resource
    return unless resource.respond_to?(:defined_attribute_locales)
    definitions = resource.defined_attribute_locales || {}

    definitions.each do |name, locales|
      locales.each do |locale|
        if locale.to_s == I18n.locales.default.to_s
          old_prop = manifest["#{name}_t_#{locale}"]

          property = Dormouse::Property.new(manifest, name, resource.table_name)
          property.populate(:type => old_prop.type, :hidden => old_prop.hidden)
          property.populate(old_prop.options)
          manifest.push property
        end

        manifest.delete("#{name}_t_#{locale}")
      end
    end

  end

end