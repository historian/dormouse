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
    widgets = self.map do |property|
      render_widget(property, view, object, options)
    end

    widgets.join('')
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

    view.send(:render, :partial => partial, :locals => locals)
  end

end