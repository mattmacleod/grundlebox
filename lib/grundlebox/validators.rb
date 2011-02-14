module Grundlebox
  module Validators
    
    class TreeValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if record.id && (record.id==record[attribute])
          record.errors[attribute] << (options[:message] || "cannot refer to self") 
        end
      end
    end
    
    class UrlValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return unless record[attribute]
        unless record[attribute].match Grundlebox::Config::UrlRegexp
          record.errors[attribute] << (options[:message] || "contains invalid characters") 
        end
      end
    end
    
  end
end

ActiveRecord::Base.send(:include, Grundlebox::Validators)
