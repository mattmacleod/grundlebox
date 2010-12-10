module Grundlebox #:nodoc:
  module ModelExtensions #:nodoc:
    module Versions #:nodoc:
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      
      module ClassMethods
        
        def grundlebox_has_versions( *attributes )
          
          has_paper_trail :only => attributes
          has_many :drafts, :as => :item, :dependent => :destroy
          
          include Grundlebox::ModelExtensions::Versions::InstanceMethods
          
        end

      end
      
      module InstanceMethods
      
        def save_draft( user, data )
          begin
            transaction do
              drafts.first.destroy if drafts.first
              drafts.create!( :user => user, :user_name => user.name, :item_data => data )
              return drafts.first
            end
          rescue
            return nil
          end
        end
        
        def has_draft?
          !!drafts.first
        end
        
        # There is only one draft
        def load_draft
          return self unless self.drafts.first
          self.attributes = self.attributes.merge( drafts.first.item_data )
          return self
        end
      
      end
      
    end
  end
end
 
ActiveRecord::Base.send(:include, Grundlebox::ModelExtensions::Versions)
