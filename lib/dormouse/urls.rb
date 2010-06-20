# @author Simon Menke
class Dormouse::Urls

  def initialize(manifest_or_property)
    if Dormouse::Property === manifest_or_property
      @property = manifest_or_property
    end
    @resource = manifest_or_property.resource
  end

  # Build a url to the `index` action for this resource.
  # If `parent` is given the url will be relative to the parent.
  # @param [ActiveRecord::Base] parent The parent resource.
  # @return [String] a url
  def index(parent=nil)
    @index ||= [base_url, local_part].join('/')
    expand(@index, nil, parent)
  end

  # Build a url to the `new` action for this resource.
  # If `parent` is given the url will be relative to the parent.
  # @param [ActiveRecord::Base] parent The parent resource.
  # @return [String] a url
  def new(parent=nil)
    @new ||= [base_url, local_part, 'new'].join('/')
    expand(@new, nil, parent)
  end

  # Build a url to the `create` action for this resource.
  # If `parent` is given the url will be relative to the parent.
  # @param [ActiveRecord::Base] parent The parent resource.
  # @return [String] a url
  def create(parent=nil)
    @create ||= [base_url, local_part].join('/')
    expand(@create, nil, parent)
  end

  # Build a url to the `show` action for the resource `object`.
  # @param [ActiveRecord::Base] object The resource.
  # @return [String] a url
  def show(object)
    @show ||= [base_url, local_part, ':id'].join('/')
    expand(@show, object, nil)
  end

  # Build a url to the `edit` action for the resource `object`.
  # @param [ActiveRecord::Base] object The resource.
  # @return [String] a url
  def edit(object)
    @edit ||= [base_url, local_part, ':id', 'edit'].join('/')
    expand(@edit, object, nil)
  end

  # Build a url to the `update` action for the resource `object`.
  # @param [ActiveRecord::Base] object The resource.
  # @return [String] a url
  def update(object)
    @update ||= [base_url, local_part, ':id'].join('/')
    expand(@update, object, nil)
  end

  # Build a url to the `destroy` action for the resource `object`.
  # @param [ActiveRecord::Base] object The resource.
  # @return [String] a url
  def destroy(object)
    @destroy ||= [base_url, local_part, ':id'].join('/')
    expand(@destroy, object, nil)
  end

protected

  def namespace
    @namespace ||= begin
      if @property
        parent_urls = @property.manifest.urls
        parent_urls.namespace
      else
        if @resource.manifest.namespace
          @resource.manifest.namespace
        else
          namespace = @resource.to_s.split('::')
          namespace.pop
          namespace = namespace.join('/').underscore.gsub('_', '/')
        end
      end
    end
  end

  def base_url
    @base_url ||= begin
      if @property
        parent_urls = @property.manifest.urls
        if namespace.blank?
          ['', parent_urls.local_part, ':parent_id'].join('/')
        else
          ['', namespace, parent_urls.local_part, ':parent_id'].join('/')
        end
      else
        if namespace.blank?
          ''
        else
          ['', namespace].join('/')
        end
      end
    end
  end

  def local_part
    @local_part ||= begin
      if @property
        @property.names.identifier(:short => true, :plural => true)
      else
        @resource.manifest.names.identifier(:short => true, :plural => true)
      end
    end
  end

  def expand(pattern, object, parent)
    pattern = pattern.dup
    pattern.sub!(':id',        object.id.to_s) if object
    pattern.sub!(':parent_id', parent.id.to_s) if parent
    pattern
  end

end