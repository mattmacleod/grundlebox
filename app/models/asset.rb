class Asset < ActiveRecord::Base
  
  # Model definition
  ############################################################################
  
  # Relationships
  belongs_to :user
  belongs_to :asset_folder
  has_many :asset_links, :dependent => :destroy
  has_many :items, :through => :asset_links
  
  # Validation
  validates_presence_of :title, :user, :asset_folder, :asset_file_name, 
                        :asset_content_type, :asset_file_size
  
  # Sort by title by default
  default_scope :order => 'title ASC'
  
  # Paperclip attachment
  has_attached_file :asset, :styles => Grundlebox::Config::ImageFileVersions,
      :path => ":rails_root/public/assets/:rails_env/:id/:id_:style.:extension",
      :url => "/assets/:rails_env/:id/:id_:style.:extension",
      :default_url => "/images/asset_placeholders/:style.png",
      :convert_options => { :all => "-strip -colorspace RGB" },
      :processors => [:cropper], :whiny => true
  
  validates_attachment_size :asset, :less_than => Grundlebox::Config::AssetMaxUploadSize
  validates_attachment_presence :asset
  validates_attachment_content_type :asset, :content_type => Grundlebox::Config::AssetContentTypes
                             
  # Prevents Paperclip from making thumbnails of non-image files by telling it
  # not to post-process if the content-type isn't an image.
  define_callbacks :post_process, :terminator => "result == false"
  set_callback(:post_process, :before, :image?)
  
  def image?
    return ["application/pdf", "image/jpeg", "image/pjpeg", "image/png", "image/x-png", "image/gif"].include?(self.asset_content_type)
  end
   
end