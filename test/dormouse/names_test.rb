require File.expand_path('../../test_helper', __FILE__)

class DormouseNamesTest < ActiveSupport::TestCase
  
  context "AdminBlog::Post" do
    
    should '#names.class_name equals "AdminBlog::Post"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.class_name, "AdminBlog::Post"
    end
    
    should '#names.class_name(:short => true) equals "Post"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.class_name(:short => true), "Post"
    end
    
    should '#names.class_name(:plural => true) equals "AdminBlog::Posts"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.class_name(:plural => true), "AdminBlog::Posts"
    end
    
    should '#names.identifier equals "admin_blog_post"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.identifier, "admin_blog_post"
    end
    
    should '#names.identifier(:short => true) equals "post"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.identifier(:short => true), "post"
    end
    
    should '#names.identifier(:plural => true) equals "admin_blog_posts"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.identifier(:plural => true), "admin_blog_posts"
    end
    
    should '#names.human equals "Admin blog post"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.human, "Admin blog post"
    end
    
    should '#names.human(:short => true) equals "Post"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.human(:short => true), "Post"
    end
    
    should '#names.human(:plural => true) equals "Admin blog posts"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.human(:plural => true), "Admin blog posts"
    end
    
    should '#names.class_namespace equals "AdminBlog"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.class_namespace, "AdminBlog"
    end
    
    should '#names.controller_class_name equals "AdminBlog::Post::ResourcesController"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.controller_class_name, "AdminBlog::Post::ResourcesController"
    end
    
    should '#names.controller_name equals "admin_blog/post/resources"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.controller_name, "admin_blog/post/resources"
    end
    
    should '#names.param_id equals "post_id"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.param_id, "post_id"
    end
    
    should '#names.param_ids equals "post_ids"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.param_ids, "post_ids"
    end
    
    should '#names.param equals "admin_blog_post"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.param, "admin_blog_post"
    end
    
    should '#names.params equals "admin_blog_posts"' do
      names = AdminBlog::Post.manifest.names
      assert_equal names.params, "admin_blog_posts"
    end
    
  end
  
  context "Admin::Blog::Post" do
    
    should '#names.class_name equals "Admin::Blog::Post"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.class_name, "Admin::Blog::Post"
    end
    
    should '#names.class_name(:short => true) equals "Post"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.class_name(:short => true), "Post"
    end
    
    should '#names.class_name(:plural => true) equals "Admin::Blog::Posts"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.class_name(:plural => true), "Admin::Blog::Posts"
    end
    
    should '#names.identifier equals "admin_blog_post"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.identifier, "admin_blog_post"
    end
    
    should '#names.identifier(:short => true) equals "post"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.identifier(:short => true), "post"
    end
    
    should '#names.identifier(:plural => true) equals "admin_blog_posts"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.identifier(:plural => true), "admin_blog_posts"
    end
    
    should '#names.human equals "Admin blog post"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.human, "Admin blog post"
    end
    
    should '#names.human(:short => true) equals "Post"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.human(:short => true), "Post"
    end
    
    should '#names.human(:plural => true) equals "Admin blog posts"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.human(:plural => true), "Admin blog posts"
    end
    
    should '#names.class_namespace equals "Admin::Blog"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.class_namespace, "Admin::Blog"
    end
    
    should '#names.controller_class_name equals "Admin::Blog::Post::ResourcesController"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.controller_class_name, "Admin::Blog::Post::ResourcesController"
    end
    
    should '#names.controller_name equals "admin/blog/post/resources"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.controller_name, "admin/blog/post/resources"
    end
    
    should '#names.param_id equals "post_id"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.param_id, "post_id"
    end
    
    should '#names.param_ids equals "post_ids"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.param_ids, "post_ids"
    end
    
    should '#names.param equals "admin_blog_post"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.param, "admin_blog_post"
    end
    
    should '#names.params equals "admin_blog_posts"' do
      names = Admin::Blog::Post.manifest.names
      assert_equal names.params, "admin_blog_posts"
    end
    
  end

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
  
end
