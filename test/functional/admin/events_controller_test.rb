require File.dirname(__FILE__) + '/../../test_helper'

class Admin::EventsControllerTest < ActionController::TestCase
  
  
  # Test routes
  ###########################################################################
  
  should "route to correct event pages" do
    assert_routing "/admin/events",         { :controller=>"admin/events", :action=>"index" }
    assert_routing "/admin/events/new",     { :controller=>"admin/events", :action=>"new" }
    assert_routing "/admin/events/1",       { :controller=>"admin/events", :action=>"show", :id => "1" }
    assert_routing "/admin/events/1/edit",  { :controller=>"admin/events", :action=>"edit", :id => "1" }
    assert_routing "/admin/events.csv",     { :controller=>"admin/events", :action=>"index", :format => "csv" }
  end

  
end