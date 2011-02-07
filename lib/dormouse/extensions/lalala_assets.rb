module Dormouse::Extensions::LalalaAssets

  def self.call(manifest)
    resource = manifest.resource

    if resource.respond_to?(:singular_attachments)
      resource.singular_attachments.each do |attachment|
        asset = "#{attachment.to_s.singularize}_asset".to_sym
        allocation = "#{attachment.to_s.singularize}_allocation".to_sym
        manifest[asset].populate(:hidden => true)
        manifest[allocation].populate(:label => attachment.to_s.humanize)
      end
    end

    if resource.respond_to?(:plural_attachments)
      resource.plural_attachments.each do |attachment|
        assets = "#{attachment.to_s.singularize}_assets".to_sym
        allocations = "#{attachment.to_s.singularize}_allocations".to_sym
        manifest[assets].populate(:hidden => true)
        manifest[allocations].populate(:label => attachment.to_s.humanize)
      end
    end

  end

end