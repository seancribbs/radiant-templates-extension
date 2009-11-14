require File.dirname(__FILE__) + '/../spec_helper'

# Re-raise errors caught by the controller.
Admin::PartTypesController.class_eval { def rescue_action(e) raise e end }

describe Admin::PartTypesController do
  dataset :users

  before :each do
    login_as :admin
  end

  it "should require login for all actions" do
    logout
    lambda { get :index }.should                    require_login
    lambda { get :new }.should                      require_login
    lambda { get :edit, :id => 1 }.should           require_login
    lambda { post :create }.should                  require_login
    lambda { put :update, :id => 1 }.should         require_login
    lambda { delete :destroy, :id => 1 }.should     require_login
  end

  describe "Access control" do
    before :each do
      @part_type = mock_model(PartType, :save => true, :update_attributes => true,
                                  :destroy => true)
      PartType.stub!(:find).and_return(@part_type)
      PartType.stub!(:new).and_return(@part_type)
    end
    
    [:admin].each do |user|
      describe "#{user} user" do
        before :each do
          login_as user
        end

        def redirects_to_index
          response.should be_redirect
          response.should redirect_to(admin_templates_path + "#part_types")
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

      end
    end

    [:existing, :non_admin, :developer].each do |user|
      describe "#{user} user" do
        before :each do
          login_as user
        end

        def redirects_to_pages
          response.should be_redirect
          response.should redirect_to(admin_pages_path)
          flash[:error].should == 'You must have admin privileges to perform this action.'
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

        after :each do
          redirects_to_pages
        end
      end
    end
  end
  
  describe "GET to /admin/templates/part_types/new" do
    def do_get
      get :new
    end
    
    it "should load a new part type" do
      do_get
      assigns[:part_type].should_not be_nil
      assigns[:part_type].should be_new_record
    end
    
    it "should render the new part type" do
      do_get
      response.should render_template('new')
    end
  end
  
  describe "GET to /admin/templates/part_types/1/edit" do
    before :each do
      @part_type = mock_model(PartType)
      PartType.should_receive(:find).with('1').at_least(:once).and_return(@part_type)
    end
    
    def do_get
      get :edit, :id => '1'
    end
    
    it "should load the existing part type" do
      do_get
      assigns[:part_type].should == @part_type
    end
    
    it "should render the edit part type" do
      do_get
      response.should render_template('edit')
    end
  end
  
  describe "POST to /admin/templates/part_types" do
    before :each do
      @part_type = mock_model(PartType)
      PartType.should_receive(:new).at_least(:once).and_return(@part_type)
    end
    
    def do_post
      post :create
    end
    
    describe "success path" do
      before :each do
        @part_type.should_receive(:save).and_return(true)
      end
      
      it "should redirect to the index" do
        do_post
        response.should redirect_to('/admin/templates#part_types')
      end
    end
    
    describe "failure path" do
      before :each do
        @part_type.should_receive(:save).and_return(false)
      end
      
      it "should add a flash error message" do
        do_post
        flash[:error].should be
      end
      
      it "should render the new part_type again" do
        do_post
        response.should render_template('new')
      end
    end
  end
  
  describe "PUT to /admin/templates/part_types/1" do
    before :each do
      @part_type = mock_model(PartType)
      PartType.should_receive(:find).with('1').at_least(:once).and_return(@part_type)
    end
    
    def do_put
      put :update, :id => '1'
    end
    
    describe "success path" do
      before :each do
        @part_type.should_receive(:update_attributes).and_return(true)
      end
      
      it "should redirect to the index" do
        do_put
        response.should redirect_to('/admin/templates#part_types')
      end
    end
    
    describe "failure path" do
      before :each do
        @part_type.should_receive(:update_attributes).and_return(false)
      end
      
      it "should add a flash error message" do
        do_put
        flash[:error].should be
      end
      
      it "should render the edit part type again" do
        do_put
        response.should render_template('edit')
      end
    end
  end
  
  describe "DELETE to /admin/templates/part_types/1" do
    before :each do
      @part_type = mock_model(PartType, :destroy => true)
      PartType.should_receive(:find).with('1').at_least(:once).and_return(@part_type)
    end
    
    def do_delete
      delete :destroy, :id => '1'
    end
    
    it "should destroy the part type" do
      @part_type.should_receive(:destroy).and_return(true)
      do_delete
    end
    
    it "should redirect to the index" do
      do_delete
      response.should redirect_to('/admin/templates#part_types')
    end
  end
end