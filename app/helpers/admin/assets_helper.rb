module Admin::AssetsHelper
  
  def get_folder_url(folder)
    controller.action_name=="browse_for_attach" ? attach_admin_asset_folders_path(folder.path) : browse_admin_asset_folders_path(folder.path)
  end
  
  def asset_breadcrumbs
    content_tag(:div, 
      content_tag(:strong, "You are here:", :class=>"title")+
      @current_folder.ancestors.map{|f| 
        link_to f.name, get_folder_url(f)
      }.join(" &raquo; ").html_safe, :class=>"asset_breadcrumbs").html_safe
  end
  
  def asset_folder_tree(folder)
    path = get_folder_url(folder)
    
    if folder.children.length > 0
      content_tag :li, content_tag(:a, folder.name, :href => path,:class=>("current" if @current_folder==folder)) +
      content_tag(:ul, folder.children.map{|f| asset_folder_tree(f) }.join.html_safe ) 
    else
      content_tag :li, content_tag(:a, folder.name, :href => path, :class=>("current" if @current_folder==folder))
    end
  end
  
  def image_folder_options(folder, selected, prefix="")
    if folder.children.length > 0
      content_tag(:option, "#{prefix} #{folder.name}".strip, :value => folder.id, :selected => (selected==folder)) +
      folder.children.map{|f| image_folder_options(f, selected, "#{prefix}--") }.join.html_safe
    else
      content_tag :option, "#{prefix} #{folder.name}".strip, :value => folder.id, :selected => (selected==folder)
    end
  end
  
end
