class Dormouse::Names
  
  def initialize(manifest_or_property)
    if Dormouse::Property === manifest_or_property
      @property = manifest_or_property
    end
    @resource = manifest_or_property.resource
  end
  
  def class_name(options={})
    if options[:short] and options[:plural]
      @short_plural_class_name ||= class_name(:short => true).pluralize
    elsif options[:plural]
      @long_plural_class_name ||= class_name.pluralize
    elsif options[:short]
      @short_singular_class_name ||= class_name.split('::').last
    else
      @long_singular_class_name ||= @resource.to_s
    end
  end
  
  def identifier(options={})
    @identifier ||= {}
    @identifier[options] ||= begin
      if @property
        if @property.plural?
          @property.name.to_s.singularize
        else
          @property.name.to_s
        end
      else
        class_name(options).gsub('::', '').underscore
      end
    end
  end
  
  def human(options={})
    @human ||= {}
    @human[options] ||= begin
      identifier(options).humanize
    end
  end
  
  def class_namespace
    @class_namespace ||= begin
      namespace = class_name.split('::')
      namespace.pop
      namespace.join('::')
    end
  end
  
  def controller_class_name
    @controller_class_name ||= "#{class_name}::ResourcesController"
  end
  
  def controller_name
    @controller_name ||= "#{class_name(:short => true)}::Resources".underscore
  end
  
  def controller_namespace
    @controller_namespace ||= begin
      class_namespace.underscore
    end
  end
  
  def param_id
    @param_id ||= "#{identifier}_id".underscore
  end
  
  def param_ids
    @param_ids ||= "#{identifier}_ids".underscore
  end
  
  def param
    @param ||= class_name.gsub('::', '').underscore
  end
  
  def params
    @params ||= class_name(:plural => true).gsub('::', '').underscore
  end
  
end