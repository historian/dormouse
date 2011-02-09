describe "Dormouse::Manifest" do
  extend ModelBuilder

  before do
    Dormouse.stub!(:style).and_return('dormouse')
    Dormouse.stub!(:default_namespace).and_return('admin')
    Dormouse.stub!(:extensions).and_return([])
  end

  describe 'without associations:' do
    describe 'Admin::BlogPost' do
      using_in_memory_database

      let_table 'admin_blog_posts' do |t|
        t.string :title
        t.text   :body

        t.timestamps
      end

      let_model 'Admin::BlogPost' do
        set_table_name :admin_blog_posts
      end

      let(:manifest) { Admin::BlogPost.manifest }

      it "has four proprties (title, body, created_at, updated_at)" do
        manifest.properties.should == %w( title body created_at updated_at )
      end

      it "has two hidden proprties (created_at, updated_at)" do
        hidden = manifest.select { |p| p.hidden }.map { |p| p.name }
        hidden.should == %w( created_at updated_at )
      end

      it "has title as its primary_name_column" do
        manifest.primary_name_column.should == 'title'
      end

      it "has no secondary_name_column" do
        manifest.secondary_name_column.should be_nil
      end

      it "understands what :_primary means" do
        manifest[:_primary].name.should == 'title'
      end

      it "understands what :_secondary means" do
        manifest[:_secondary].should be_nil
      end

      describe "#title" do
        subject { manifest[:title] }

        it { should be_column }
        it { should_not be_reflection  }
        it { should_not be_association }
        it { should_not be_polymorphic }
        it { should_not be_plural  }
        its(:type)     { should == :string }
        its(:name)     { should == 'title' }
        its(:label)    { should == 'Title' }
        its(:table)    { should == 'admin_blog_posts' }
        its(:resource) { should be_nil }

      end

      describe "#body" do
        subject { manifest[:body] }

        it { should be_column }
        it { should_not be_reflection  }
        it { should_not be_association }
        it { should_not be_polymorphic }
        it { should_not be_plural  }
        its(:type)     { should == :text }
        its(:name)     { should == 'body' }
        its(:label)    { should == 'Body' }
        its(:table)    { should == 'admin_blog_posts' }
        its(:resource) { should be_nil }

      end
    end
  end

  describe 'with associations:' do
    using_in_memory_database

    let_table 'admin_blog_posts' do |t|
      t.string :title
      t.text   :body

      t.timestamps
    end

    let_table 'admin_blog_comments' do |t|
      t.integer :post_id
      t.text    :body

      t.timestamps
    end

    let_model 'Admin::Blog::Post' do
      set_table_name :admin_blog_posts

      has_many :comments
    end

    let_model 'Admin::Blog::Comment' do
      set_table_name :admin_blog_comments

      belongs_to :post,
        :class_name => 'Admin::Blog::Post'
    end

    describe "Admin::Blog::Post" do
      let(:manifest) { Admin::Blog::Post.manifest }

      it "has five proprties (title, body, created_at, updated_at, comments)" do
        manifest.properties.should == %w( title body created_at updated_at comments )
      end

      describe "#comments" do
        subject { manifest[:comments] }

        it { should_not be_column }
        it { should be_reflection  }
        it { should be_association }
        it { should_not be_polymorphic }
        it { should be_plural  }
        its(:type)     { should == :has_many }
        its(:name)     { should == 'comments' }
        its(:label)    { should == 'Comments' }
        its(:table)    { should be_nil }
        its(:resource) { subject.to_s.should == 'Admin::Blog::Comment' }

      end
    end

    describe "Admin::Blog::Comment" do
      let(:manifest) { Admin::Blog::Comment.manifest }

      it "has five proprties (body, created_at, updated_at, post)" do
        manifest.properties.should == %w( body created_at updated_at post )
      end

      describe "#post" do
        subject { manifest[:post] }

        it { should_not be_column }
        it { should be_reflection  }
        it { should be_association }
        it { should_not be_polymorphic }
        it { should_not be_plural  }
        its(:type)     { should == :belongs_to }
        its(:name)     { should == 'post' }
        its(:label)    { should == 'Post' }
        its(:table)    { should be_nil }
        its(:resource) { subject.to_s.should == 'Admin::Blog::Post' }

      end
    end

  end

end