require File.dirname(__FILE__) + '/../test_helper'

class ApiControllerTest < ActionController::TestCase
  
  
  # Test routes
  ###########################################################################
  
  should "route to correct API pages" do
    assert_routing "/api/v1/users.xml", { 
      :version=>"1", :format => "xml", :controller=>"api", :action=>"users"
    }
    assert_routing "/api/v1/users.json", { 
      :version=>"1", :format => "json", :controller=>"api", :action=>"users"
    }
  end
  
  
  # API doesn't require login, but check key provision
  ###########################################################################
  
  context "with an API key" do
    setup do
      @api_key = Factory(:api_key)
      @params = { :version => "1", :key => @api_key.display_code, :format=>"xml" }
    end
    
    context "and at least one user" do
      setup { @user = Factory(:user) }
      
      context "and a format type of :xml" do
        setup { @params[:format] = :xml }
      
        context "a get an xml list of users" do
          setup do
            get :users, @params
          end
          should respond_with :success
          should respond_with_content_type :xml
          should_not render_with_layout
          should "respond with the user records" do
            assert_xml_select "users"
          end
        end
    
      end
      
      context "and a format type of :json" do
        setup { @params[:format] = :json }
      
        context "a get a json list of users" do
          setup do
            get :users, @params
          end
          should respond_with :success
          should respond_with_content_type :json
          should_not render_with_layout
        end
    
      end
      
    end
    
    context "a request with a valid but nonexistent API key" do
      setup do
        @params = { :version => "1", :key => "#{@api_key.id}-blahblablah", :format=>"xml" }
        get :users, @params
      end
      should respond_with :forbidden
      should_not render_with_layout
    end

    context "a request with an invalid API key" do
      setup do
        @params = { :version => "1", :key => "blahblablah", :format=>"xml" }
        get :users, @params
      end
      should respond_with :forbidden
      should_not render_with_layout
    end
    
  end
  
end