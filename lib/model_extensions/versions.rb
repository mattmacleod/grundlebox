module Grundlebox #:nodoc:
  module ModelExtensions #:nodoc:
    module Versions #:nodoc:
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      
      module ClassMethods
        
        def grundlebox_has_versions( *attributes )
          has_paper_trail :only => attributes
        end

      end
      
    end
  end
end
 
ActiveRecord::Base.send(:include, Grundlebox::ModelExtensions::Versions)
