class ActiveSupport::TestCase

  class << self
    
    def should_have_grundlebox_url(target_attribute = :url, options = {})
      options[:generated_from] ? generated_from = options[:generated_from] : generated_from = "title"
      klass = self.name.gsub(/Test$/, '').underscore.to_sym
      
      context "an existing item" do
        setup { @item = Factory(klass) }
        should validate_presence_of target_attribute

        should "update url field when source attribute is changed" do
          @item[generated_from] = "This is å néw nåmê ø!"
          @item.save!
          assert_equal "this_a_new_name_o", @item.send(target_attribute)
        end
        
        should "limit length of url field when source attribute is changed" do
          @item[generated_from] = "This is a very long title and parts of it should be chopped out after this"
          @item.save!
          assert_equal "this_a_very_long_title_parts_it_should_chopped_out", @item.send(target_attribute)
        end
        
        should "respond to to_param method" do
          assert_equal("#{@item.id}-#{@item.send(target_attribute)}", @item.send(:to_param))
        end
        
      end
    end
  
  end
  
end