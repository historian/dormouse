class Dormouse::Views::Form < Dormouse::Views::Base
  
  def render(object=nil)
    manifest = self.manifest
    
    widgets  = self.widgets
    
    object ||= begin
      if id = @controller.params[:id]
        manifest.resource.find(id)
      else
        manifest.resource.new
      end
    end
      
    controller_eval do
      @object   = object
      @widgets  = widgets
      render :template => "#{manifest.style}/views/form", :layout => "#{manifest.style}/layouts/dormouse"
    end
  end
  
  def widgets
    @widgets ||= begin
      manifest.inject([]) do |memo, property|
        case property.type
        when :string then
          memo << Dormouse::Widgets::String.new(manifest, property)
        when :text then
          memo << Dormouse::Widgets::Text.new(manifest, property)
        when :date then
          memo << Dormouse::Widgets::Date.new(manifest, property)
        when :time then
          memo << Dormouse::Widgets::Time.new(manifest, property)
        when :datetime then
          memo << Dormouse::Widgets::Datetime.new(manifest, property)
        when :boolean then
          memo << Dormouse::Widgets::Boolean.new(manifest, property)
        when :integer then
          memo << Dormouse::Widgets::Integer.new(manifest, property)
        when :float then
          memo << Dormouse::Widgets::Float.new(manifest, property)
        when :decimal then
          memo << Dormouse::Widgets::Decimal.new(manifest, property)
        when :timestamp then
          memo << Dormouse::Widgets::Timestamp.new(manifest, property)
        when :belongs_to then
          memo << Dormouse::Widgets::BelongsTo.new(manifest, property)
        end
        memo
      end
    end
  end
  
end