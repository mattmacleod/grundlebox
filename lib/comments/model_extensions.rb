module Grundlebox #:nodoc:
  module Has #:nodoc:
    module Comments #:nodoc:
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      
      module ClassMethods
        
        def grundlebox_has_comments(options={})
          has_many :comments, :as => :item, :dependent => :destroy
          include Grundlebox::Has::Comments::InstanceMethods
        end

      end


      module InstanceMethods
        
        def comment_count
          return comments.visible.count
        end
        
      end
      
    end
  end
end
 
ActiveRecord::Base.send(:include, Grundlebox::Has::Comments)
