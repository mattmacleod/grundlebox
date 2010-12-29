require File.dirname(__FILE__) + '/../../test_helper'

class Admin::AssetFoldersControllerTest < ActionController::TestCase
  
  
  # Test routes
  ###########################################################################
  
  should "route to correct asset folder pages" do
    assert_routing "/admin/asset_folders",                { :controller=>"admin/asset_folders", :action=>"index" }
    assert_routing "/admin/asset_folders/new",            { :controller=>"admin/asset_folders", :action=>"new" }
    assert_routing "/admin/asset_folders/1/edit",         { :controller=>"admin/asset_folders", :action=>"edit", :id=> "1" }
    assert_routing "/admin/asset_folders/1-root",         { :controller=>"admin/asset_folders", :action=>"index", :path=> "1-root" }
  end
  

  # Check lists
  ###########################################################################
  
  context "when logged in as an admin user with a root asset folder" do
    setup do
      @user = Factory(:admin_user)
      login_as @user
      @root_folder = Factory(:asset_folder, :name => "root", :parent => nil)
    end
    
    context "a get to :new" do
      setup { get :new }
      should render_template :new
      should respond_with :success
      should_not set_the_flash
      should "display the new asset folder form" do
        assert assigns(:asset_folder)
        assert assigns(:asset_folder).is_a? AssetFolder
        assert_select "input#asset_folder_name"
      end
    end
    
    context "a post to :create with invalid details" do
      setup { post :create, :asset_folder=>{:name=>""} }
      should_show_errors
      should render_template :new
      should_not set_the_flash
    end
    
    
    context "a post to :create with valid details" do
      setup { post :create, :asset_folder=>{
        :name => "test folder", :parent_id => @root_folder.id
        } 
      }
      should redirect_to "/admin/asset_folders/1-root/2-test_folder"
      should set_the_flash do /saved/i end
    end
    
    context "a DELETE to the root folder" do
      setup { delete :destroy, :id=>@root_folder.id }
      should respond_with :redirect
      should redirect_to "/admin/asset_folders"
      should set_the_flash do /failed/i end
    end
    
    context "a GET to the asset folder edit page" do
      setup { get :edit, :id=>@root_folder.id }
      should "respond with the asset folder editing form" do
        assert_equal @root_folder, assigns(:asset_folder)
      end
    end
     
    context "a GET to the root folder show page" do
      setup { get :show, :id=>@root_folder.id }
      should respond_with :redirect
      should redirect_to "/admin/asset_folders/1-root"
    end
    
    context "a GET to a nonexistent asset folder management page" do
      setup { get :index, :path=>"0-root"  }
      should respond_with :redirect
      should redirect_to "/admin/asset_folders/1-root"
    end   
    
    context "with subfolders" do
      setup do 
        @folder1 = Factory(:asset_folder, :parent => @root_folder, :name => "Test")
      end
      
      context "a GET to the asset folder browser page for the subfolder" do
        setup { get :index, :path => "1-root/#{@folder1.id}-test" }
        should "return no assets" do
          assert_equal [], assigns(:assets)
        end
        should "display the correct folder path" do
          assert_select "ul.asset_folder_list a.current"
        end
        should "display the correct breadcumbs" do
          assert_select("div.asset_breadcrumbs") { "Test" }
        end
      end
      
      context "a DELETE to an asset folder page" do
        setup { delete :destroy, :id => @folder1.id }
        should respond_with :redirect
        should redirect_to "/admin/asset_folders/1-root"
        should set_the_flash do /deleted/i end
      end
      
      context "a GET to the new asset folder page" do
        setup { get :new }
        should "contain a select menu including the subfolder" do
          assert_select "select option", "-- Test"
        end
      end
      
      context "a POST to the asset folder update page with valid details" do
        setup { post :update, :id => @folder1.id, :asset_folder=>{
          :name => "test folder", :parent_id => @root_folder.id
          } 
        }
        should respond_with :redirect
        should set_the_flash do /saved/i end
      end

      context "a POST to the asset folder update page with invalid details" do
        setup { post :update, :id => @folder1.id, :asset_folder=>{:name=>""} }
        should respond_with :success
        should render_template :edit
        should_show_errors
      end
      
    end
    
    context "containing multiple assets," do
      setup do
        @assets = [ 
          @asset = Factory(:asset, :asset_folder => @root_folder, :title => "test"), 
          @asset2 = Factory(:asset, :asset_folder => @root_folder, :title => "other") 
        ]
      end
      
      context "a GET to :index" do
        setup { get :index }
        should redirect_to "/admin/asset_folders/1-root"
      end
      
      context "a GET to the asset browser page" do
        setup { get :index, :path => "1-root" }
        should "return all assets" do
          assert_same_elements @assets, assigns(:assets)
        end
      end
      
      context "a GET to the asset browser page with a search string" do
        setup { get :index, :path => "1-root", :q => "other" }
        should "return matching assets" do
          assert_same_elements [@asset2], assigns(:assets)
        end
      end
      
      context "an xhr GET to the asset browser" do
        setup { xhr :get, :index, :path => "1-root" }
        should "return all assets" do
          assert_same_elements @assets, assigns(:assets)
        end
      end
      
      context "an xhr GET to the asset browser for a specific page" do
        setup { xhr :get, :index, :path => "1-root", :page => "2" }
        should "return no assets" do
          assert_same_elements [], assigns(:assets)
        end
      end
      
      context "an xhr GET to the asset browser with a query" do
        setup { xhr :get, :index, :path => "1-root", :q => "other" }
        should "return one asset" do
          assert_same_elements [@asset2], assigns(:assets)
        end
      end
      
    end
  end
  
  
end
