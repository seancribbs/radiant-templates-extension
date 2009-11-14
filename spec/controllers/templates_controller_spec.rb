require File.dirname(__FILE__) + '/../spec_helper'

# Re-raise errors caught by the controller.
Admin::TemplatesController.class_eval { def rescue_action(e) raise e end }

describe Admin::TemplatesController do
  dataset :users

  before :each do
    login_as :developer
  end

  it "should require login for all actions" do
    logout
    lambda { get :index }.should                    require_login
    lambda { get :new }.should                      require_login
    lambda { get :edit, :id => 1 }.should           require_login
    lambda { post :create }.should                  require_login
    lambda { put :update, :id => 1 }.should         require_login
    lambda { delete :destroy, :id => 1 }.should     require_login
    lambda { post :move_higher, :id => 1}.should    require_login
    lambda { post :move_lower, :id => 1}.should     require_login
    lambda { post :move_to_top, :id => 1}.should    require_login
    lambda { post :move_to_bottom, :id => 1}.should require_login
  end

  describe "Access control" do
    before :each do
      @template = mock_model(Template, :save => true, :update_attributes => true,
                                  :destroy => true, :move_to_top => true, :move_to_bottom => true,
                                  :move_higher => true, :move_lower => true)
      Template.stub!(:find).and_return(@template)
      Template.stub!(:new).and_return(@template)
    end
    
    [:admin, :developer].each do |user|
      describe "#{user} user" do
        before :each do
          login_as user
        end

        def redirects_to_index
          response.should be_redirect
          response.should redirect_to(admin_templates_path)
        end

        it 'should have access to the index action' do
          get :index
          response.should be_success
        end

        it 'should have access to the new action' do
          get :new
          response.should be_success
        end

        it 'should have access to the create action' do
          post :create
          redirects_to_index
        end

        it 'should have access to the edit action' do
          get :edit, :id => 1
          response.should be_success
        end

        it 'should have access to the update action' do
          put :update, :id => 1
          redirects_to_index
        end

        it 'should have access to the destroy action' do
          delete :destroy, :id => 1
          redirects_to_index
        end

        [:move_higher, :move_lower, :move_to_top, :move_to_bottom].each do |action|
          it "should have access to the #{action} action" do
            post action, :id => 1
            redirects_to_index
          end
        end
      end
    end

    [:existing, :non_admin].each do |user|
      describe "#{user} user" do
        before :each do
          login_as user
        end

        def redirects_to_pages
          response.should be_redirect
          response.should redirect_to(admin_pages_path)
          flash[:error].should == 'You must have developer privileges to perform this action.'
        end

        it 'should not have access to the index action' do
          get :index
        end

        it 'should not have access to the new action' do
          get :new
        end

        it 'should not have access to the create action' do
          post :create
        end

        it 'should not have access to the edit action' do
          get :edit, :id => 1
        end

        it 'should not have access to the update action' do
          put :update, :id => 1
        end

        it 'should not have access to the destroy action' do
          delete :destroy, :id => 1
        end

        [:move_higher, :move_lower, :move_to_top, :move_to_bottom].each do |action|
          it "should not have access to the #{action} action" do
            post action, :id => 1
          end
        end

        after :each do
          redirects_to_pages
        end
      end
    end
  end
  
  describe "GET to /admin/templates" do
    before :each do
      @template = mock_model(Template)
      Template.should_receive(:find).with(:all).and_return([@template])
    end
    def do_get
      get :index
    end
    
    it "should load all templates" do
      do_get
      assigns[:content_templates].should == [@template]
    end
    
    it "should render the index template" do
      do_get
      response.should render_template('index')
    end
  end
  
  describe "GET to /admin/templates/new" do
    def do_get
      get :new
    end
    
    it "should load a new template" do
      do_get
      assigns[:content_template].should_not be_nil
      assigns[:content_template].should be_new_record
    end
    
    it "should render the new template" do
      do_get
      response.should render_template('new')
    end
  end
  
  describe "GET to /admin/templates/1/edit" do
    before :each do
      @template = mock_model(Template)
      Template.should_receive(:find).with('1').and_return(@template)
    end
    
    def do_get
      get :edit, :id => '1'
    end
    
    it "should load the existing template" do
      do_get
      assigns[:content_template].should == @template
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template('edit')
    end
  end
  
  describe "POST to /admin/templates" do
    before :each do
      @template = mock_model(Template)
      Template.should_receive(:new).and_return(@template)
    end
    
    def do_post
      post :create
    end
    
    describe "success path" do
      before :each do
        @template.should_receive(:save).and_return(true)
      end
      
      it "should redirect to the index" do
        do_post
        response.should redirect_to('/admin/templates')
      end
    end
    
    describe "failure path" do
      before :each do
        @template.should_receive(:save).and_return(false)
      end
      
      it "should add a flash error message" do
        do_post
        flash[:error].should be
      end
      
      it "should render the new template again" do
        do_post
        response.should render_template('new')
      end
    end
  end
  
  describe "PUT to /admin/templates/1" do
    before :each do
      @template = mock_model(Template)
      Template.should_receive(:find).with('1').and_return(@template)
    end
    
    def do_put
      put :update, :id => '1'
    end
    
    describe "success path" do
      before :each do
        @template.should_receive(:update_attributes).and_return(true)
      end
      
      it "should redirect to the index" do
        do_put
        response.should redirect_to('/admin/templates')
      end
    end
    
    describe "failure path" do
      before :each do
        @template.should_receive(:update_attributes).and_return(false)
      end
      
      it "should add a flash error message" do
        do_put
        flash[:error].should be
      end
      
      it "should render the edit template again" do
        do_put
        response.should render_template('edit')
      end
    end
  end
  
  describe "DELETE to /admin/templates/1" do
    before :each do
      @template = mock_model(Template, :destroy => true)
      Template.should_receive(:find).with('1').and_return(@template)
    end
    
    def do_delete
      delete :destroy, :id => '1'
    end
    
    it "should destroy the template" do
      @template.should_receive(:destroy).and_return(true)
      do_delete
    end
    
    it "should redirect to the index" do
      do_delete
      response.should redirect_to('/admin/templates')
    end
  end
  
  [:move_to_top, :move_to_bottom, :move_higher, :move_lower].each do |action|
    describe "POST to /admin/templates/1/#{action}" do
      before :each do
        @template = mock_model(Template, action => true)
        Template.should_receive(:find).with('1').and_return(@template)
      end
      
      define_method :do_post do
        post action, :id => '1'
      end
      
      it "should call #{action} on the template" do
        @template.should_receive(action).and_return(true)
        do_post
      end
      
      it "should redirect back to the index" do
        do_post
        response.should redirect_to('/admin/templates')
      end
      
      it "should register that templates are being reordered" do
        Template.should_receive(:reordering)
        do_post
      end
    end
  end
end