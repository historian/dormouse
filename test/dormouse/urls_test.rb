require File.expand_path('../../test_helper', __FILE__)

class DormouseUrlsTest < ActiveSupport::TestCase

  def self.builds(variant, varguments, result, rarguments)
    should "#urls.#{variant}(#{varguments.inspect}) calls #helpers.#{result}(#{rarguments.inspect})" do
      helpers = mock('helpers') do
        expects(result).with(*rarguments)
      end
      Dormouse::URLs.helpers = helpers
      @urls.__send__(variant, *varguments)
    end
  end

  context "AdminBlog::Post" do

    setup do
      @urls = Dormouse::URLs.new(
        Dormouse::Names.new("AdminBlog::Post"),
        nil,
        nil)
    end

    builds :index,                 [],
           :admin_blog_posts_path, []

    builds :show,                 [5],
           :admin_blog_post_path, [5]

    builds :new,                      [],
           :new_admin_blog_post_path, []

    builds :edit,                      [5],
           :edit_admin_blog_post_path, [5]

    builds :create,                [],
           :admin_blog_posts_path, []

    builds :update,               [5],
           :admin_blog_post_path, [5]

    builds :destroy,              [5],
           :admin_blog_post_path, [5]

    builds :create_many,                       [],
           :create_many_admin_blog_posts_path, []

    builds :update_many,                       [],
           :update_many_admin_blog_posts_path, []

    builds :destroy_many,                       [],
           :destroy_many_admin_blog_posts_path, []

  end

  context "Admin::Blog::Post" do

    setup do
      @urls = Dormouse::URLs.new(
        Dormouse::Names.new("Admin::Blog::Post"),
        nil,
        nil)
    end

    builds :index,                 [],
           :admin_blog_posts_path, []

    builds :show,                 [5],
           :admin_blog_post_path, [5]

    builds :new,                      [],
           :new_admin_blog_post_path, []

    builds :edit,                      [5],
           :edit_admin_blog_post_path, [5]

    builds :create,                [],
           :admin_blog_posts_path, []

    builds :update,               [5],
           :admin_blog_post_path, [5]

    builds :destroy,              [5],
           :admin_blog_post_path, [5]

    builds :create_many,                       [],
           :create_many_admin_blog_posts_path, []

    builds :update_many,                       [],
           :update_many_admin_blog_posts_path, []

    builds :destroy_many,                       [],
           :destroy_many_admin_blog_posts_path, []

  end

  context "Admin::BlogPost" do

    setup do
      @urls = Dormouse::URLs.new(
        Dormouse::Names.new("Admin::BlogPost"),
        nil,
        nil)
    end

    builds :index,                 [],
           :admin_blog_posts_path, []

    builds :show,                 [5],
           :admin_blog_post_path, [5]

    builds :new,                      [],
           :new_admin_blog_post_path, []

    builds :edit,                      [5],
           :edit_admin_blog_post_path, [5]

    builds :create,                [],
           :admin_blog_posts_path, []

    builds :update,               [5],
           :admin_blog_post_path, [5]

    builds :destroy,              [5],
           :admin_blog_post_path, [5]

    builds :create_many,                       [],
           :create_many_admin_blog_posts_path, []

    builds :update_many,                       [],
           :update_many_admin_blog_posts_path, []

    builds :destroy_many,                       [],
           :destroy_many_admin_blog_posts_path, []

  end

  context "BlogPost" do

    setup do
      @urls = Dormouse::URLs.new(
        Dormouse::Names.new("BlogPost"),
        nil,
        nil)
    end

    builds :index,           [],
           :blog_posts_path, []

    builds :show,           [5],
           :blog_post_path, [5]

    builds :new,                [],
           :new_blog_post_path, []

    builds :edit,                [5],
           :edit_blog_post_path, [5]

    builds :create,          [],
           :blog_posts_path, []

    builds :update,         [5],
           :blog_post_path, [5]

    builds :destroy,        [5],
           :blog_post_path, [5]

    builds :create_many,                 [],
           :create_many_blog_posts_path, []

    builds :update_many,                 [],
           :update_many_blog_posts_path, []

    builds :destroy_many,                 [],
           :destroy_many_blog_posts_path, []

  end

  context "BlogPost" do

    setup do
      @urls = Dormouse::URLs.new(
        Dormouse::Names.new("BlogPost"),
        nil,
        'cms')
    end

    builds :index,               [],
           :cms_blog_posts_path, []

    builds :show,               [5],
           :cms_blog_post_path, [5]

    builds :new,                    [],
           :new_cms_blog_post_path, []

    builds :edit,                    [5],
           :edit_cms_blog_post_path, [5]

    builds :create,              [],
           :cms_blog_posts_path, []

    builds :update,             [5],
           :cms_blog_post_path, [5]

    builds :destroy,            [5],
           :cms_blog_post_path, [5]

    builds :create_many,                     [],
           :create_many_cms_blog_posts_path, []

    builds :update_many,                     [],
           :update_many_cms_blog_posts_path, []

    builds :destroy_many,                     [],
           :destroy_many_cms_blog_posts_path, []

  end

  context "Admin::Blog::Comment" do

    setup do
      @urls = Dormouse::URLs.new(
        Dormouse::Names.new("Admin::Comment", :approved_comment),
        Dormouse::Names.new("Admin::Post"),
        nil)
    end

    builds :index,                             [3],
           :admin_post_approved_comments_path, [3]

    builds :show,               [5],
           :admin_comment_path, [5]

    builds :new,                                  [3],
           :new_admin_post_approved_comment_path, [3]

    builds :edit,                    [5],
           :edit_admin_comment_path, [5]

    builds :create,                            [3],
           :admin_post_approved_comments_path, [3]

    builds :update,             [5],
           :admin_comment_path, [5]

    builds :destroy,            [5],
           :admin_comment_path, [5]

    builds :create_many,                                   [3],
           :create_many_admin_post_approved_comments_path, [3]

    builds :update_many,                     [],
           :update_many_admin_comments_path, []

    builds :destroy_many,                     [],
           :destroy_many_admin_comments_path, []

  end

  context "Admin::Blog::Comment" do

    setup do
      @urls = Dormouse::URLs.new(
        Dormouse::Names.new("Admin::Comment", :approved_comment),
        Dormouse::Names.new("Admin::Post"),
        'cms')
    end

    builds :index,                             [3],
           :cms_post_approved_comments_path, [3]

    builds :show,               [5],
           :cms_comment_path, [5]

    builds :new,                                  [3],
           :new_cms_post_approved_comment_path, [3]

    builds :edit,                    [5],
           :edit_cms_comment_path, [5]

    builds :create,                            [3],
           :cms_post_approved_comments_path, [3]

    builds :update,             [5],
           :cms_comment_path, [5]

    builds :destroy,            [5],
           :cms_comment_path, [5]

    builds :create_many,                                   [3],
           :create_many_cms_post_approved_comments_path, [3]

    builds :update_many,                     [],
           :update_many_cms_comments_path, []

    builds :destroy_many,                     [],
           :destroy_many_cms_comments_path, []

  end

end