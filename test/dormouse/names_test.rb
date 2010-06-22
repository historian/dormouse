require File.expand_path('../../test_helper', __FILE__)

class DormouseNamesTest < ActiveSupport::TestCase

  def self.builds(result, variant, options={})
    should "#names.#{variant}(#{options.inspect}) equals #{result.inspect}" do
      assert_equal @names.__send__(variant, options), result
    end
  end

  context "AdminBlog::Post" do

    setup do
      @names = Dormouse::Names.new("AdminBlog::Post", nil, nil, false)
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
      @names = Dormouse::Names.new("Admin::Blog::Post", nil, nil, false)
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
      @names = Dormouse::Names.new("Admin::BlogPost", nil, nil, false)
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
      @names = Dormouse::Names.new("BlogPost", nil, nil, false)
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
      @names = Dormouse::Names.new("AdminBlog::Post", :related_post, nil, false)
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

  context "#title" do

    setup do
      @names = Dormouse::Names.new(nil, :title, nil, false)
    end

    builds nil, :class_name
    builds nil, :class_name, :short => true
    builds nil, :class_name, :plural => true

    builds "title",  :identifier
    builds "title",  :identifier, :short => true
    builds "titles", :identifier, :plural => true

    builds "Title",  :human
    builds "Title",  :human, :short => true
    builds "Titles", :human, :plural => true

    builds nil, :class_namespace
    builds nil, :controller_class_name
    builds nil, :controller_name

    builds nil,      :param_id
    builds nil,      :param_ids
    builds "title",  :param
    builds "titles", :params

  end

  context "#short_description" do

    setup do
      @names = Dormouse::Names.new(nil, :short_description, nil, false)
    end

    builds nil, :class_name
    builds nil, :class_name, :short => true
    builds nil, :class_name, :plural => true

    builds "short_description",  :identifier
    builds "short_description",  :identifier, :short => true
    builds "short_descriptions", :identifier, :plural => true

    builds "Short description",  :human
    builds "Short description",  :human, :short => true
    builds "Short descriptions", :human, :plural => true

    builds nil, :class_namespace
    builds nil, :controller_class_name
    builds nil, :controller_name

    builds nil,                  :param_id
    builds nil,                  :param_ids
    builds "short_description",  :param
    builds "short_descriptions", :params

  end

end
