module Grundlebox #:nodoc:
  module ModelExtensions #:nodoc:
    module Assets #:nodoc:
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      

      module ClassMethods
        
        def grundlebox_has_assets(options={})
          has_many :asset_links, :as => :item, :order => :sort_order, 
                   :include => :asset, :dependent => :destroy
          has_many :assets, :through => :asset_links
          include Grundlebox::ModelExtensions::Assets::InstanceMethods
        end

      end


      module InstanceMethods
        
        def main_image
          return nil unless assets.count > 0
          return assets.order("sort_order ASC").first
        end
        
      end
      
    end
  end
end
 
ActiveRecord::Base.send(:include, Grundlebox::ModelExtensions::Assets)
