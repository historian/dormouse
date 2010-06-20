module Dormouse::Extentions::Globalize

  def self.call(manifest)
    if manifest['globalize_translations']

      property = manifest.delete('globalize_translations')
      model    = property.resource
      table    = model.table_name

      model.content_columns.each do |column|
        next if %w( created_at updated_at locale ).include? column.name.to_s
        manifest.push Dormouse::Property.new(manifest, column, table)
      end

    end
  end

end