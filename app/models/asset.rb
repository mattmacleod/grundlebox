class Asset < ActiveRecord::Base
  
  # Model definition
  ############################################################################
  
  ImageContentTypes = ["application/pdf", "image/jpeg", "image/pjpeg", "image/png", "image/x-png", "image/gif"]
  
  # Relationships
  belongs_to :user
  belongs_to :asset_folder
  has_many :asset_links, :dependent => :destroy
  has_many :items, :through => :asset_links
  
  # Validation
  validates_presence_of :title, :user, :asset_folder, :asset
  
  # Sort by title by default
  default_scope :order => 'title ASC'
  
  
  # Paperclip details
  ############################################################################
  
  # Setup the attachment
  has_attached_file :asset, :styles => Grundlebox::Config::ImageFileVersions,
      :path => ":rails_root/public/assets/:rails_env/:id/:id_:style.:extension",
      :url => "/assets/:rails_env/:id/:id_:style.:extension",
      :default_url => "/images/asset_placeholders/:style.png",
      :convert_options => { :all => "-strip -colorspace RGB" },
      :processors => [:cropper], :whiny => true
  
  
  # Validate attachments
  validates_attachment_size :asset, :less_than => Grundlebox::Config::AssetMaxUploadSize
  validates_attachment_presence :asset
  validates_attachment_content_type :asset, :content_type => Grundlebox::Config::AssetContentTypes
     
                          
  # Prevents Paperclip from making thumbnails of non-image files by telling it
  # not to post-process if the content-type isn't an image.
  define_callbacks :post_process, :terminator => "result == false"
  set_callback(:post_process, :before, :image?)
  def image?
    return ImageContentTypes.include?(self.asset_content_type)
  end
  
  # Returnt the type of this asset so we know how to display it on the front end
  def asset_type
    
    if asset_content_type=="application/pdf"
      return :pdf
    elsif image?
      return :image
    elsif asset_content_type=="application/msword"
      return :doc
    elsif asset_content_type=="application/vnd.ms-excel"
      return :xls
    elsif asset_content_type=="application/zip"
      return :zip
    else
      return :generic
    end
    
  end
  
  # Handle cropping
  after_update :reprocess_cropped_styles
  Grundlebox::Config::ImageFileVersions.keys.each do |k|
    attr_accessor "crop_x_#{k}", "crop_y_#{k}", "crop_w_#{k}", "crop_h_#{k}"
  end
  def reprocess_cropped_styles 
    Grundlebox::Config::ImageFileVersions.keys.select{|k| cropping?( k )}.each do |style|
      asset.reprocess!( style )
    end
  end
  def cropping?( style )
    ["crop_x_#{style}", "crop_y_#{style}", "crop_w_#{style}", "crop_h_#{style}"].flatten.any?{|a| !(self.send(a).blank?) }
  end
   
end