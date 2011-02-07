module Dormouse::Extensions::Paperclip

  def self.call(manifest)
    resource = manifest.resource
    return unless resource.respond_to?(:attachment_definitions)
    definitions = resource.attachment_definitions || {}

    definitions.each do |name, options|
      manifest.delete("#{name}_file_name")
      manifest.delete("#{name}_file_size")
      manifest.delete("#{name}_content_type")
      manifest.delete("#{name}_updated_at")

      property = Dormouse::Property.new(manifest, name)
      property.populate :hidden => false, :type => :file
      manifest.push property
    end

  end

end