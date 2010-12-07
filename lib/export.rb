module Grundlebox #:nodoc:
  module ExportColumns #:nodoc:
               
      def self.included(base)
        base.extend(ClassMethods)
      end
         
      module ClassMethods
        def grundlebox_set_export_columns( columns )
          cattr_accessor :default_export_columns
          self.default_export_columns = columns
          include Grundlebox::ExportColumns::InstanceMethods
        end
      end
      

      module InstanceMethods
        def to_xml( options )
          options.reverse_merge!( { :only=>self.class.default_export_columns.values }) unless options[:except]
          return super(options)
        end
      end
      
  end
end
 
ActiveRecord::Base.send(:include, Grundlebox::ExportColumns)
