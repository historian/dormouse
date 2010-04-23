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
  
  def initialize(manifest_or_property)
    if Dormouse::Property === manifest_or_property
      @property = manifest_or_property
    end
    @resource = manifest_or_property.resource
  end
  
  # Build the class name of this resource
  # @option options [Boolean] :short (false) only the last part
  # @option options [Boolean] :plural (false) pluralize the name
  # @return [String]
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
  
  # Build an identifier name.
  # @option options [Boolean] :short (false) only the last part
  # @option options [Boolean] :plural (false) pluralize the name
  # @return [String]
  def identifier(options={})
    @identifier ||= {}
    @identifier[options] ||= begin
      if @property
        if @property.plural?
          if options[:plural]
            @property.name.to_s
          else
            @property.name.to_s.singularize
          end
        else
          if options[:plural]
            @property.name.to_s
          else
            @property.name.to_s.pluralize
          end
        end
      else
        class_name(options).gsub('::', '').underscore
      end
    end
  end
  
  # Build a human name.
  # @option options [Boolean] :short (false) only the last part
  # @option options [Boolean] :plural (false) pluralize the name
  # @return [String]
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
    @controller_name ||= "#{class_name}::Resources".underscore
  end
  
  def controller_namespace
    @controller_namespace ||= begin
      class_namespace.underscore.gsub('_', '/')
    end
  end
  
  def param_id
    @param_id ||= "#{identifier(:short => true)}_id".underscore
  end
  
  def param_ids
    @param_ids ||= "#{identifier(:short => true)}_ids".underscore
  end
  
  def param
    @param ||= class_name.gsub('::', '').underscore
  end
  
  def params
    @params ||= class_name(:plural => true).gsub('::', '').underscore
  end
  
end