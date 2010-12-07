module Grundlebox #:nodoc:
  module ModelExtensions #:nodoc:
    module Versions #:nodoc:
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      
      module ClassMethods
        
        def grundlebox_has_versions(options={})
          include Grundlebox::ModelExtensions::Versions::InstanceMethods
        end

      end


      module InstanceMethods
        
      end
      
    end
  end
end
 
ActiveRecord::Base.send(:include, Grundlebox::ModelExtensions::Versions)
