module Admin::ArticlesHelper
  
  # Form helpers
  ############################################################################
  
  def article_type_options( selected = nil )
    out = "<option></option>" +
    Grundlebox::Config::ArticleTypes.map{|k,v| [v,k] }.sort{|a,b| a.first<=>b.first }.map do |type|
      content_tag(:option, type.first, :value => type.last, :selected => ( type.first==selected ) )
    end.join.html_safe
  end
  
  
  def publication_options(selected = nil)
    out = "<option>Web-only</option>" +
    @all_publications.map do |key, value|
      options = value.map{|v|
        content_tag(:option, v.name, :value => v.id, :selected => ( v==selected || (selected.nil? && key != :past && v==value.first) ) )
      }.join.html_safe
      content_tag(:optgroup, options, :label => ( key==:past ? "Past publications" : "Future publications") )
    end.join.html_safe
  end
  
  def section_options_for_list(selected=nil)
    out = @all_sections.map do |section|
      content_tag( 
        :option, 
        section.name, 
        :value => url_for( 
          :section_id => section.id, 
          :publication_id => params[:publication_id],
          :q => params[:q]
        ), 
        :selected => ( section.id == params[:section_id].to_i )
      )
    end
    out = out.unshift(
      content_tag( :option, "--All sections--", :value => url_for(:section_id=>nil, :publication_id => params[:publication_id], :q => params[:q]) )
    )
    out.join.html_safe
  end
  
  def publication_options_for_list(selected = nil)
    out = @all_publications.map do |key, value|
      options = value.map{|v|
        content_tag( 
          :option, 
          v.name, 
          :value => url_for(
            :publication_id => v.id, 
            :section_id => params[:section_id],
            :q => params[:q]
          ), 
          :selected => ( v.id == params[:publication_id].to_i ) 
        )
      }.join.html_safe
      content_tag( :optgroup, options, :label => (key==:past ? "Past publications" : "Future publications"))
    end
    out = out.unshift(
      content_tag( 
        :option, 
        "--All publications--", 
        :value => url_for(:publication_id=>nil, :section_id => params[:section_id], :q => params[:q])
      )
    )
    out.join.html_safe
  end
  
end
