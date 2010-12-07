require File.dirname(__FILE__) + '/../test_helper'

class VenueTest < ActiveSupport::TestCase

  # Metatests
  ############################################################################
  should_be_valid_with_factory
  
 
  # Attributes and methods
  ############################################################################
  
  # Relationships
  should belong_to :user
  should belong_to :city
  should have_many :performances
  should have_many(:events).through(:performances)
  should have_and_belong_to_many :articles

  # Custom bits
  should_have_grundlebox_tags
  should_have_grundlebox_comments
  #should_have_grundlebox_assets
  should_have_grundlebox_lock
  should_have_grundlebox_url :url, :generated_from => :title

  # Validations
  ############################################################################
  should validate_presence_of :title
  should validate_presence_of :user
  should_validate_email :email

  
  # Location tests
  ############################################################################
  context "a Venue without a location" do
    setup { @venue = Factory(:venue) }
    subject { @venue }
    should "not be marked as having a location" do
      assert !@venue.has_location?
    end
  end
  
  context "a collection of Venues with locations" do
    setup do
      @city = Factory(:city)
      @venue1 = Factory(:venue, :lat=>55.9, :lng=>-3.2, :city=>@city)
      @venue2 = Factory(:venue, :lat=>55.93, :lng=>-3.21, :city=>@city)
      @venue3 = Factory(:venue, :lat=>55.931, :lng=>-3.211, :city=>@city)
      @venue4 = Factory(:venue, :lat=>2, :lng=>2)
    end
    should "be marked as having locations" do
      [@venue1, @venue2, @venue3, @venue4].each{|v| assert v.has_location? }
    end
    should "find nearby venues in the same city" do
      assert_same_elements [@venue2, @venue3], @venue1.nearby.all
      assert_same_elements [@venue1, @venue2], @venue3.nearby.all
      assert_same_elements [@venue1, @venue3], @venue2.nearby.all
    end
    should "find correct distance between venues" do
      assert_in_delta 2.1, @venue1.distance_from(@venue2), 0.1
    end
    should "find venues in region ordered by distance" do
      assert_equal [@venue1, @venue2, @venue3], Venue::in_region(55.9, -3.2, 10).all
    end
  end
  
end