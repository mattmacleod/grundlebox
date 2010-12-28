module Admin::TagsHelper
  
  def tag_manager_link( tag )
    content_tag(
      :span,
      link_to( tag.name+" (#{tag.taggings.length})", admin_tag_path(tag), :class => "show" )+
      link_to( "delete tag", admin_tag_path(tag), :class => "delete", :method => :delete ),
      :class => "tag"
    )
  end
  
end
