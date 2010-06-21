# @author Simon Menke
class Dormouse::URLs

  extend ActiveSupport::Memoizable

  class << self
    attr_accessor :helpers

    def helpers
      @helpers ||= ActionController::Base.helpers
    end
  end

  def initialize(names, parent_names, namespace)
    @names        = names
    @parent_names = parent_names
    @namespace    = namespace
  end

  # Build a url to the `index` action for this resource.
  # If `parent` is given the url will be relative to the parent.
  # @param [ActiveRecord::Base] parent The parent resource.
  # @return [String] a url
  def index(parent=nil)
    if @parent_names
      Dormouse::URLs.helpers.__send__ index_helper, parent
    else
      Dormouse::URLs.helpers.__send__ index_helper
    end
  end

  def index_helper
    if @parent_names
      [
        @namespace || begin
          namespace = @parent_names.class_namespace
          if namespace
            namespace.underscore.gsub('/', '_')
          else
            nil
          end
        end,
        @parent_names.identifier(:short => true),
        @names.identifier(:short => true, :plural => true),
        'path'
      ].compact.join('_')
    else
      [
        @namespace || begin
          namespace = @names.class_namespace
          if namespace
            namespace.underscore.gsub('/', '_')
          else
            nil
          end
        end,
        @names.identifier(:short => true, :plural => true),
        'path'
      ].compact.join('_')
    end
  end

  memoize :index_helper
  private :index_helper

  # Build a url to the `show` action for the resource `object`.
  # @param [ActiveRecord::Base] object The resource.
  # @return [String] a url
  def show(object)
    Dormouse::URLs.helpers.__send__ show_helper, object
  end

  def show_helper
    [
      @namespace || begin
        namespace = @names.class_namespace
        if namespace
          namespace.underscore.gsub('/', '_')
        else
          nil
        end
      end,
      @names.class_name(:short => true).underscore.gsub('/', '_'),
      'path'
    ].compact.join('_')
  end

  memoize :show_helper
  private :show_helper

  # Build a url to the `new` action for this resource.
  # If `parent` is given the url will be relative to the parent.
  # @param [ActiveRecord::Base] parent The parent resource.
  # @return [String] a url
  def new(parent=nil)
    if @parent_names
      Dormouse::URLs.helpers.__send__ new_helper, parent
    else
      Dormouse::URLs.helpers.__send__ new_helper
    end
  end

  def new_helper
    if @parent_names
      [
        'new',
        @namespace || begin
          namespace = @parent_names.class_namespace
          if namespace
            namespace.underscore.gsub('/', '_')
          else
            nil
          end
        end,
        @parent_names.identifier(:short => true),
        @names.identifier(:short => true),
        'path'
      ].compact.join('_')
    else
      [
        'new',
        @namespace || begin
          namespace = @names.class_namespace
          if namespace
            namespace.underscore.gsub('/', '_')
          else
            nil
          end
        end,
        @names.identifier(:short => true),
        'path'
      ].compact.join('_')
    end
  end

  memoize :new_helper
  private :new_helper

  # Build a url to the `edit` action for the resource `object`.
  # @param [ActiveRecord::Base] object The resource.
  # @return [String] a url
  def edit(object)
    Dormouse::URLs.helpers.__send__ edit_helper, object
  end

  def edit_helper
    [
      'edit',
      @namespace || begin
        namespace = @names.class_namespace
        if namespace
          namespace.underscore.gsub('/', '_')
        else
          nil
        end
      end,
      @names.class_name(:short => true).underscore.gsub('/', '_'),
      'path'
    ].compact.join('_')
  end

  memoize :edit_helper
  private :edit_helper

  # Build a url to the `create` action for this resource.
  # If `parent` is given the url will be relative to the parent.
  # @param [ActiveRecord::Base] parent The parent resource.
  # @return [String] a url
  def create(parent=nil)
    if @parent_names
      Dormouse::URLs.helpers.__send__ create_helper, parent
    else
      Dormouse::URLs.helpers.__send__ create_helper
    end
  end

  def create_helper
    if @parent_names
      [
        @namespace || begin
          namespace = @parent_names.class_namespace
          if namespace
            namespace.underscore.gsub('/', '_')
          else
            nil
          end
        end,
        @parent_names.identifier(:short => true),
        @names.identifier(:short => true, :plural => true),
        'path'
      ].compact.join('_')
    else
      [
        @namespace || begin
          namespace = @names.class_namespace
          if namespace
            namespace.underscore.gsub('/', '_')
          else
            nil
          end
        end,
        @names.identifier(:short => true, :plural => true),
        'path'
      ].compact.join('_')
    end
  end

  memoize :create_helper
  private :create_helper

  # Build a url to the `update` action for the resource `object`.
  # @param [ActiveRecord::Base] object The resource.
  # @return [String] a url
  def update(object)
    Dormouse::URLs.helpers.__send__ update_helper, object
  end

  def update_helper
    [
      @namespace || begin
        namespace = @names.class_namespace
        if namespace
          namespace.underscore.gsub('/', '_')
        else
          nil
        end
      end,
      @names.class_name(:short => true).underscore.gsub('/', '_'),
      'path'
    ].compact.join('_')
  end

  memoize :update_helper
  private :update_helper

  # Build a url to the `destroy` action for the resource `object`.
  # @param [ActiveRecord::Base] object The resource.
  # @return [String] a url
  def destroy(object)
    Dormouse::URLs.helpers.__send__ destroy_helper, object
  end

  def destroy_helper
    [
      @namespace || begin
        namespace = @names.class_namespace
        if namespace
          namespace.underscore.gsub('/', '_')
        else
          nil
        end
      end,
      @names.class_name(:short => true).underscore.gsub('/', '_'),
      'path'
    ].compact.join('_')
  end

  memoize :destroy_helper
  private :destroy_helper

  # Build a url to the `create_many` action for this resource.
  # If `parent` is given the url will be relative to the parent.
  # @param [ActiveRecord::Base] parent The parent resource.
  # @return [String] a url
  def create_many(parent=nil)
    if @parent_names
      Dormouse::URLs.helpers.__send__ create_many_helper, parent
    else
      Dormouse::URLs.helpers.__send__ create_many_helper
    end
  end

  def create_many_helper
    if @parent_names
      [
        'create_many',
        @namespace || begin
          namespace = @parent_names.class_namespace
          if namespace
            namespace.underscore.gsub('/', '_')
          else
            nil
          end
        end,
        @parent_names.identifier(:short => true),
        @names.identifier(:short => true, :plural => true),
        'path'
      ].compact.join('_')
    else
      [
        'create_many',
        @namespace || begin
          namespace = @names.class_namespace
          if namespace
            namespace.underscore.gsub('/', '_')
          else
            nil
          end
        end,
        @names.identifier(:short => true, :plural => true),
        'path'
      ].compact.join('_')
    end
  end

  memoize :create_many_helper
  private :create_many_helper

  # Build a url to the `update_many` action for this resource.
  # @return [String] a url
  def update_many
    Dormouse::URLs.helpers.__send__ update_many_helper
  end

  def update_many_helper
    [
      'update_many',
      @namespace || begin
        namespace = @names.class_namespace
        if namespace
          namespace.underscore.gsub('/', '_')
        else
          nil
        end
      end,
      @names.class_name(:short => true, :plural => true).underscore.gsub('/', '_'),
      'path'
    ].compact.join('_')
  end

  memoize :update_many_helper
  private :update_many_helper

  # Build a url to the `destroy_many` action for this resource.
  # @return [String] a url
  def destroy_many
    Dormouse::URLs.helpers.__send__ destroy_many_helper
  end

  def destroy_many_helper
    [
      'destroy_many',
      @namespace || begin
        namespace = @names.class_namespace
        if namespace
          namespace.underscore.gsub('/', '_')
        else
          nil
        end
      end,
      @names.class_name(:short => true, :plural => true).underscore.gsub('/', '_'),
      'path'
    ].compact.join('_')
  end

  memoize :destroy_many_helper
  private :destroy_many_helper

end