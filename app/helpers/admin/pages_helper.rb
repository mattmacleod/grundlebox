module Admin::PagesHelper
  
  def page_tree( root )

     if root.children.length > 0
       content_tag :li, link_to(root.title, edit_admin_page_path( root )) +
       content_tag(:ul, root.children.map{|p| page_tree(p) }.join.html_safe ), 
       :id => "page_node_#{root.id}",
       :class => "jstree-open"
     else
       content_tag :li, link_to(root.title, edit_admin_page_path( root )), 
       :id => "page_node_#{root.id}"
     end
   end
   
   def page_options( page, selected_id, prefix="" )
     if page.children.length > 0
       content_tag(:option, "#{prefix} #{page.title}".strip, :value => page.id, :selected => (selected_id==page.id)) +
       page.children.map{|f| page_options(f, selected_id, "#{prefix}--") }.join.html_safe
     else
       content_tag :option, "#{prefix} #{page.title}".strip, :value => page.id, :selected => (selected_id==page.id)
     end
   end
   
end
