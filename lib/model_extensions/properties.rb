module Grundlebox #:nodoc:
  module ModelExtensions #:nodoc:
    module Properties #:nodoc:
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      
      module ClassMethods
        
        def grundlebox_has_properties
          serialize :properties
          include Grundlebox::ModelExtensions::Properties::InstanceMethods
        end

      end


      module InstanceMethods
        
        def properties=( props )
          return nil unless props.is_a? Hash
          self[:properties] = props
        end
        
        def properties
          self[:properties] || {}
        end
        
      end
      
    end
  end
end
 
ActiveRecord::Base.send(:include, Grundlebox::ModelExtensions::Properties)
