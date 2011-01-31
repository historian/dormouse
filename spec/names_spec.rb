describe "Dormouse::Names for" do

  describe "AdminBlog::Post" do

    let(:names) { Dormouse::Names.new("AdminBlog::Post", nil, nil, false) }

    it { names.class_name.should == "AdminBlog::Post" }
    it { names.class_name(:short => true).should == "Post" }
    it { names.class_name(:plural => true).should == "AdminBlog::Posts" }

    it { names.identifier.should == "admin_blog_post" }
    it { names.identifier(:short => true).should == "post" }
    it { names.identifier(:plural => true).should == "admin_blog_posts" }

    it { names.human.should == "Admin blog post" }
    it { names.human(:short => true).should == "Post" }
    it { names.human(:plural => true).should == "Admin blog posts" }

    it { names.class_namespace.should == "AdminBlog" }
    it { names.controller_class_name.should == "AdminBlog::Post::ResourcesController" }
    it { names.controller_name.should == "admin_blog/post/resources" }

    it { names.param_id.should == "post_id" }
    it { names.param_ids.should == "post_ids" }
    it { names.param.should == "admin_blog_post" }
    it { names.params.should == "admin_blog_posts" }

  end

  describe "Admin::Blog::Post" do

    let(:names) { Dormouse::Names.new("Admin::Blog::Post", nil, nil, false) }

    it { names.class_name.should == "Admin::Blog::Post" }
    it { names.class_name(:short => true).should == "Post" }
    it { names.class_name(:plural => true).should == "Admin::Blog::Posts" }

    it { names.identifier.should == "admin_blog_post" }
    it { names.identifier(:short => true).should == "post" }
    it { names.identifier(:plural => true).should == "admin_blog_posts" }

    it { names.human.should == "Admin blog post" }
    it { names.human(:short => true).should == "Post" }
    it { names.human(:plural => true).should == "Admin blog posts" }

    it { names.class_namespace.should == "Admin::Blog" }
    it { names.controller_class_name.should == "Admin::Blog::Post::ResourcesController" }
    it { names.controller_name.should == "admin/blog/post/resources" }

    it { names.param_id.should == "post_id" }
    it { names.param_ids.should == "post_ids" }
    it { names.param.should == "admin_blog_post" }
    it { names.params.should == "admin_blog_posts" }

  end

  describe "Admin::BlogPost" do

    let(:names) { Dormouse::Names.new("Admin::BlogPost", nil, nil, false) }

    it { names.class_name.should == "Admin::BlogPost" }
    it { names.class_name(:short => true).should == "BlogPost" }
    it { names.class_name(:plural => true).should == "Admin::BlogPosts" }

    it { names.identifier.should == "admin_blog_post" }
    it { names.identifier(:short => true).should == "blog_post" }
    it { names.identifier(:plural => true).should == "admin_blog_posts" }

    it { names.human.should == "Admin blog post" }
    it { names.human(:short => true).should == "Blog post" }
    it { names.human(:plural => true).should == "Admin blog posts" }

    it { names.class_namespace.should == "Admin" }
    it { names.controller_class_name.should == "Admin::BlogPost::ResourcesController" }
    it { names.controller_name.should == "admin/blog_post/resources" }

    it { names.param_id.should == "blog_post_id" }
    it { names.param_ids.should == "blog_post_ids" }
    it { names.param.should == "admin_blog_post" }
    it { names.params.should == "admin_blog_posts" }

  end

  describe "BlogPost" do

    let(:names) { Dormouse::Names.new("BlogPost", nil, nil, false) }

    it { names.class_name.should == "BlogPost" }
    it { names.class_name(:short => true).should == "BlogPost" }
    it { names.class_name(:plural => true).should == "BlogPosts" }

    it { names.identifier.should == "blog_post" }
    it { names.identifier(:short => true).should == "blog_post" }
    it { names.identifier(:plural => true).should == "blog_posts" }

    it { names.human.should == "Blog post" }
    it { names.human(:short => true).should == "Blog post" }
    it { names.human(:plural => true).should == "Blog posts" }

    it { names.class_namespace.should be_nil }
    it { names.controller_class_name.should == "BlogPost::ResourcesController" }
    it { names.controller_name.should == "blog_post/resources" }

    it { names.param_id.should == "blog_post_id" }
    it { names.param_ids.should == "blog_post_ids" }
    it { names.param.should == "blog_post" }
    it { names.params.should == "blog_posts" }

  end

  describe "AdminBlog::Post#related_post" do

    let(:names) { Dormouse::Names.new("AdminBlog::Post", :related_post, nil, false) }

    it { names.class_name.should == "AdminBlog::Post" }
    it { names.class_name(:short => true).should == "Post" }
    it { names.class_name(:plural => true).should == "AdminBlog::Posts" }

    it { names.identifier.should == "related_post" }
    it { names.identifier(:short => true).should == "related_post" }
    it { names.identifier(:plural => true).should == "related_posts" }

    it { names.human.should == "Related post" }
    it { names.human(:short => true).should == "Related post" }
    it { names.human(:plural => true).should == "Related posts" }

    it { names.class_namespace.should == "AdminBlog" }
    it { names.controller_class_name.should == "AdminBlog::Post::ResourcesController" }
    it { names.controller_name.should == "admin_blog/post/resources" }

    it { names.param_id.should == "related_post_id" }
    it { names.param_ids.should == "related_post_ids" }
    it { names.param.should == "admin_blog_post" }
    it { names.params.should == "admin_blog_posts" }

  end

  describe "[AnyClass]#title" do

    let(:names) { Dormouse::Names.new(nil, :title, nil, false) }

    it { names.class_name.should be_nil }
    it { names.class_name(:short => true).should be_nil }
    it { names.class_name(:plural => true).should be_nil }

    it { names.identifier.should == "title" }
    it { names.identifier(:short => true).should == "title" }
    it { names.identifier(:plural => true).should == "titles" }

    it { names.human.should == "Title" }
    it { names.human(:short => true).should == "Title" }
    it { names.human(:plural => true).should == "Titles" }

    it { names.class_namespace.should be_nil }
    it { names.controller_class_name.should be_nil }
    it { names.controller_name.should be_nil }

    it { names.param_id.should be_nil }
    it { names.param_ids.should be_nil }
    it { names.param.should == "title" }
    it { names.params.should == "titles" }

  end

end
