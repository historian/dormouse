# @example AdminBlog::Post
#   names.class_name                  == "AdminBlog::Post"
#   names.class_name(:short => true)  == "Post"
#   names.class_name(:plural => true) == "AdminBlog::Posts"
#
#   names.identifier                  == "admin_blog_post"
#   names.identifier(:short => true)  == "post"
#   names.identifier(:plural => true) == "admin_blog_posts"
#
#   names.human                       == "Admin blog post"
#   names.human(:short => true)       == "Post"
#   names.human(:plural => true)      == "Admin blog posts"
#
#   names.class_namespace             == "AdminBlog"
#   names.controller_class_name       == "AdminBlog::Post::ResourcesController"
#   names.controller_name             == "admin_blog/post/resources"
#
#   names.param_id                    == "post_id"
#   names.param_ids                   == "post_ids"
#   names.param                       == "admin_blog_post"
#   names.params                      == "admin_blog_posts"
#
# @example Admin::Blog::Post
#   names.class_name                  == "Admin::Blog::Post"
#   names.class_name(:short => true)  == "Post"
#   names.class_name(:plural => true) == "Admin::Blog::Posts"
#
#   names.identifier                  == "admin_blog_post"
#   names.identifier(:short => true)  == "post"
#   names.identifier(:plural => true) == "admin_blog_posts"
#
#   names.human                       == "Admin blog post"
#   names.human(:short => true)       == "Post"
#   names.human(:plural => true)      == "Admin blog posts"
#
#   names.class_namespace             == "Admin::Blog"
#   names.controller_class_name       == "Admin::Blog::Post::ResourcesController"
#   names.controller_name             == "admin/blog/post/resources"
#
#   names.param_id                    == "post_id"
#   names.param_ids                   == "post_ids"
#   names.param                       == "admin_blog_post"
#   names.params                      == "admin_blog_posts"
#
# @example has_many :related_posts, :class_name => "AdminBlog::Post"
#   names.class_name                  == "AdminBlog::Post"
#   names.class_name(:short => true)  == "Post"
#   names.class_name(:plural => true) == "AdminBlog::Posts"
#
#   names.identifier                  == "related_post"
#   names.identifier(:short => true)  == "related_post"
#   names.identifier(:plural => true) == "related_posts"
#
#   names.human                       == "Related post"
#   names.human(:short => true)       == "Related post"
#   names.human(:plural => true)      == "Related posts"
#
#   names.class_namespace             == "AdminBlog"
#   names.controller_class_name       == "AdminBlog::Post::ResourcesController"
#   names.controller_name             == "admin_blog/post/resources"
#
#   names.param_id                    == "related_post_id"
#   names.param_ids                   == "related_post_ids"
#   names.param                       == "admin_blog_post"
#   names.params                      == "admin_blog_posts"
#
# @author Simon Menke
class Dormouse::Names

  extend ActiveSupport::Memoizable

  def initialize(resource, association=nil)
    @resource    = resource.to_s
    @association = association.to_s if association
  end

  # Build the class name of this resource
  # @option options [Boolean] :short (false) only the last part
  # @option options [Boolean] :plural (false) pluralize the name
  # @return [String]
  def class_name(options={})
    if options[:short] and options[:plural]
      class_name(:short => true).pluralize
    elsif options[:plural]
      class_name.pluralize
    elsif options[:short]
      class_name.split('::').last
    else
      @resource
    end
  end
  memoize :class_name

  # Build an identifier name.
  # @option options [Boolean] :short (false) only the last part
  # @option options [Boolean] :plural (false) pluralize the name
  # @return [String]
  def identifier(options={})
    if @association
      if options[:plural]
        @association.pluralize
      else
        @association
      end
    else
      class_name(options).gsub('::', '').underscore
    end
  end
  memoize :identifier

  # Build a human name.
  # @option options [Boolean] :short (false) only the last part
  # @option options [Boolean] :plural (false) pluralize the name
  # @return [String]
  def human(options={})
    identifier(options).humanize
  end
  memoize :human

  def class_namespace
    namespace = class_name.split('::')
    namespace.pop
    if namespace.empty?
      nil
    else
      namespace.join('::')
    end
  end
  memoize :class_namespace

  def controller_class_name
    "#{class_name}::ResourcesController"
  end
  memoize :controller_class_name

  def controller_name
    "#{class_name}::Resources".underscore
  end
  memoize :controller_name

  def controller_namespace
    class_namespace.underscore.gsub('_', '/')
  end
  memoize :controller_namespace

  def param_id
    "#{identifier(:short => true)}_id".underscore
  end
  memoize :param_id

  def param_ids
    "#{identifier(:short => true)}_ids".underscore
  end
  memoize :param_ids

  def param
    class_name.gsub('::', '').underscore
  end
  memoize :param

  def params
    class_name(:plural => true).gsub('::', '').underscore
  end
  memoize :params

end