require File.dirname(__FILE__) + '/../../test_helper'

class Admin::AssetsControllerTest < ActionController::TestCase
  
  
  # Test routes
  ###########################################################################
  
  should "route to correct asset management pages" do
    assert_routing "/admin/assets",                { :controller=>"admin/assets", :action=>"index" }
    assert_routing "/admin/assets/new",            { :controller=>"admin/assets", :action=>"new" }
    assert_routing "/admin/assets/1",              { :controller=>"admin/assets", :action=>"show", :id => "1" }
    assert_routing "/admin/assets/1/edit",         { :controller=>"admin/assets", :action=>"edit", :id=> "1" }
  end
  

  # Check lists
  ###########################################################################
  
  context "when logged in as an admin user with a root asset folder" do
    setup do
      @user = Factory(:user)
      login_as @user
      @root_folder = Factory(:asset_folder, :name => "root", :parent => nil)
    end
    
    context "a get to :index" do
      setup { get :index }
      should redirect_to "/admin/asset_folders"
    end
    
    context "a get to :new" do
      setup { get :new }
      should render_template :new
      should respond_with :success
      should_not set_the_flash
      should "display the new asset form" do
        assert assigns(:asset)
        assert assigns(:asset).is_a? Asset
        assert_select "input#asset_title"
      end
    end
    
    context "a post to :create with invalid details" do
      setup { post :create, :asset=>{:title=>""} }
      should_show_errors
      should render_template :new
      should_not set_the_flash
    end
    
    context "a post to :create with valid details" do
      setup { post :create, :asset=>{
        :title => "test asset", :asset_folder_id => @root_folder.id, 
        :attachment => fixture_file_upload("files/images/test_image_small_rgb.jpg", "image/jpeg" )
        } 
      }
      should redirect_to "/admin/asset_folders/1-root"
      should set_the_flash do /saved/i end
    end
    
    context "containing multiple assets," do
      setup do
        @assets = [ 
          @asset = Factory(:asset, :asset_folder => @root_folder, :title => "test"), 
          @asset2 = Factory(:asset, :asset_folder => @root_folder, :title => "other") 
        ]
      end
      
      context "a DELETE to the asset" do
        setup { delete :destroy, :id=>@asset.id }
        should respond_with :redirect
        should redirect_to "/admin/asset_folders/1-root"
        should set_the_flash do /deleted/i end
      end
      
      context "a GET to the asset edit page" do
        setup { get :edit, :id=>@asset2.id }
        should "respond with the asset editing form" do
          assert_equal @asset2, assigns(:asset)
        end
      end
       
      context "a GET to the asset show page" do
        setup { get :show, :id=>@asset2.id }
        should respond_with :redirect
      end
      
      context "a GET to a nonexistent asset management page" do
        setup { get :edit, :id=>0 }
        should respond_with 404
      end
      
      context "a POST to the asset update page with valid details" do
        setup { post :update, {:id=>@asset2.id, :asset=>{
          :title => "test asset", :asset_folder_id => @root_folder.id, 
          :attachment => fixture_file_upload("files/images/test_image_small_rgb.jpg", "image/jpeg" )
          }
        }}
        should respond_with :redirect
        should redirect_to "/admin/asset_folders/1-root"
        should set_the_flash do /saved/i end
      end
      
      context "a POST to the asset update page with invalid details" do
        setup { post :update, {:id=>@asset2.id, :asset=>{:title => ""}}}
        should respond_with :success
        should render_template :edit
        should_show_errors
      end      
       
    end
    
    
    
  end
  
  
end
