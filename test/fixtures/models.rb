
module AdminBlog
  class Post < ActiveRecord::Base
    set_table_name "admin_blog_post"
  end
end

module Admin
  module Blog
    class Post < ActiveRecord::Base
      set_table_name "admin_blog_post"
    end
  end
end
