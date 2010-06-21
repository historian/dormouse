# @author Simon Menke
class Dormouse::Widgets < Array

  def initialize(manifest)
    manifest.each do |property|
      next if property.hidden
      next if property.association? and !property.options[:inline]
      self << property
    end
  end

  def render(view, object, options={})
    self.inject('') do |html, property|
      html.concat render_widget(property, view, object, options)
      html
    end
  end

private

  def render_widget(property, view, object, options={})
    locals = options.merge(
      :value    => object.__send__(property.name),
      :object   => object,
      :property => property,
      :manifest => property.manifest,
      :target   => property.resource.try(:manifest)
    )

    partial = "#{property.manifest.style}/widgets/#{property.type}"

    view.instance_eval do
      render :partial => partial, :locals => locals
    end
  end

end