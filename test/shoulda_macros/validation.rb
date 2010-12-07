class ActiveSupport::TestCase

  def self.should_validate_email(attribute)
    should_not allow_value("notanemail").for(attribute)
    should_not allow_value("not@example").for(attribute)
    should_not allow_value("@example.com").for(attribute)
    
    should allow_value("test@example.com").for(attribute)
    should allow_value("text@example.co.uk").for(attribute)
    should allow_value("test@example.tv").for(attribute)
    should allow_value("!#\$%&'*+-/=?^_\`\{|\}~@example.com").for(attribute)
  end
  
end