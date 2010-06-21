require File.expand_path('../../test_helper', __FILE__)

class DormouseNamesTest < ActiveSupport::TestCase

  def self.builds(result, variant, options={})
    should "#names.#{variant}(#{options.inspect}) equals #{result.inspect}" do
      assert_equal @names.__send__(variant, options), result
    end
  end

  context "AdminBlog::Post" do

    setup do
      @names = Dormouse::Names.new("AdminBlog::Post")
    end

    builds "AdminBlog::Post",  :class_name
    builds "Post",             :class_name, :short => true
    builds "AdminBlog::Posts", :class_name, :plural => true

    builds "admin_blog_post",  :identifier
    builds "post",             :identifier, :short => true
    builds "admin_blog_posts", :identifier, :plural => true

    builds "Admin blog post",  :human
    builds "Post",             :human, :short => true
    builds "Admin blog posts", :human, :plural => true

    builds "AdminBlog",                            :class_namespace
    builds "AdminBlog::Post::ResourcesController", :controller_class_name
    builds "admin_blog/post/resources",            :controller_name

    builds "post_id",          :param_id
    builds "post_ids",         :param_ids
    builds "admin_blog_post",  :param
    builds "admin_blog_posts", :params

  end

  context "Admin::Blog::Post" do

    setup do
      @names = Dormouse::Names.new("Admin::Blog::Post")
    end

    builds "Admin::Blog::Post",  :class_name
    builds "Post",               :class_name, :short => true
    builds "Admin::Blog::Posts", :class_name, :plural => true

    builds "admin_blog_post",  :identifier
    builds "post",             :identifier, :short => true
    builds "admin_blog_posts", :identifier, :plural => true

    builds "Admin blog post",  :human
    builds "Post",             :human, :short => true
    builds "Admin blog posts", :human, :plural => true

    builds "Admin::Blog",                            :class_namespace
    builds "Admin::Blog::Post::ResourcesController", :controller_class_name
    builds "admin/blog/post/resources",            :controller_name

    builds "post_id",          :param_id
    builds "post_ids",         :param_ids
    builds "admin_blog_post",  :param
    builds "admin_blog_posts", :params

  end

  context "Admin::BlogPost" do

    setup do
      @names = Dormouse::Names.new("Admin::BlogPost")
    end

    builds "Admin::BlogPost",  :class_name
    builds "BlogPost",         :class_name, :short => true
    builds "Admin::BlogPosts", :class_name, :plural => true

    builds "admin_blog_post",  :identifier
    builds "blog_post",        :identifier, :short => true
    builds "admin_blog_posts", :identifier, :plural => true

    builds "Admin blog post",  :human
    builds "Blog post",        :human, :short => true
    builds "Admin blog posts", :human, :plural => true

    builds "Admin",                                :class_namespace
    builds "Admin::BlogPost::ResourcesController", :controller_class_name
    builds "admin/blog_post/resources",            :controller_name

    builds "blog_post_id",     :param_id
    builds "blog_post_ids",    :param_ids
    builds "admin_blog_post",  :param
    builds "admin_blog_posts", :params

  end

  context "BlogPost" do

    setup do
      @names = Dormouse::Names.new("BlogPost")
    end

    builds "BlogPost",  :class_name
    builds "BlogPost",  :class_name, :short => true
    builds "BlogPosts", :class_name, :plural => true

    builds "blog_post",  :identifier
    builds "blog_post",  :identifier, :short => true
    builds "blog_posts", :identifier, :plural => true

    builds "Blog post",  :human
    builds "Blog post",  :human, :short => true
    builds "Blog posts", :human, :plural => true

    builds nil,                              :class_namespace
    builds "BlogPost::ResourcesController", :controller_class_name
    builds "blog_post/resources",           :controller_name

    builds "blog_post_id",  :param_id
    builds "blog_post_ids", :param_ids
    builds "blog_post",     :param
    builds "blog_posts",    :params

  end

  context "AdminBlog::Post#related_posts" do

    setup do
      @names = Dormouse::Names.new("AdminBlog::Post", :related_post)
    end

    builds "AdminBlog::Post",  :class_name
    builds "Post",             :class_name, :short => true
    builds "AdminBlog::Posts", :class_name, :plural => true

    builds "related_post",  :identifier
    builds "related_post",  :identifier, :short => true
    builds "related_posts", :identifier, :plural => true

    builds "Related post",  :human
    builds "Related post",  :human, :short => true
    builds "Related posts", :human, :plural => true

    builds "AdminBlog",                            :class_namespace
    builds "AdminBlog::Post::ResourcesController", :controller_class_name
    builds "admin_blog/post/resources",            :controller_name

    builds "related_post_id",  :param_id
    builds "related_post_ids", :param_ids
    builds "admin_blog_post",  :param
    builds "admin_blog_posts", :params

  end

end
