module Grundlebox #:nodoc:
  module Has #:nodoc:
    module Url #:nodoc:
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
            
      module ClassMethods
        
        def grundlebox_has_url(attribute, options={})
                    
          cattr_accessor :url_source_attribute, :url_attribute
          before_validation :update_url
          
          self.url_source_attribute = options[:generated_from] || "title"
          self.url_attribute = attribute
          
          validates attribute, :presence=>true, :format=>{ :with=>Grundlebox::Config::UrlRegexp }
          
          include Grundlebox::Has::Url::InstanceMethods
          
        end
                
      end
      

      module InstanceMethods
                
        def update_url
          self[self.class.url_attribute] = 
            Grundlebox::Util::pretty_url( 
              self.send( self.class.url_source_attribute ).to_s 
            )
        end
        
        def to_param
          return "#{id}-#{self[self.class.url_attribute]}"
        end
        
      end
      
    end
  end
end
 
ActiveRecord::Base.send(:include, Grundlebox::Has::Url)
