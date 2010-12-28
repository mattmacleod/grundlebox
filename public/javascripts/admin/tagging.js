grundlebox.admin.tagging = {

	init: function(){
		
		if($(".tag_select").length==0){ return; }
		
		this.setup_autocomplete();	// Set up the autocomplete and tokenization
		this.setup_links();					// Set up the most popular links
		
	},

	setup_autocomplete: function(){
		$(".tag_select").autocomplete({
			
			source: function( request, response ) {
				
				$.ajax({
					url: "/admin/tags",
					dataType: "json",
					data: { q: grundlebox.admin.tagging.extract_last(request.term) },
					success: function( data ) {
						response( $.map( data, function( item ) {
							return { label: item.name, value: item.name }
						}));
					}
				});
			},
			focus: function() {
				return false
			},
			select: function( event, ui ) {
				var terms = grundlebox.admin.tagging.split_list( this.value );
				terms.pop();
				terms.push( ui.item.value );
				terms.push( "" );
				this.value = terms.join( ", " );
				return false;
			}
		});
		
		// Handle commas on end of input
		$(".tag_select").blur(function(){
			$(this).val( $(this).val().replace(/,\s$/g, ""));
		}).focus( function(){
			if( !$(this).val().match(/,\s$/g) ){
				$(this).val( $(this).val() + ", ");
			}
		})
	},
	
	setup_links: function(){
		$(".tag_select").siblings(".tag_attachment_list").find("a.tag").click(function(){
			$(this).parent().siblings(".tag_select").val( $(this).parent().siblings(".tag_select").val() + ", " + $(this).attr("title") );
			$(this).hide("slide");
			return false;
		});
	},
	
	split_list: function( list ){
		return list.split( /,\s*/ );
	},
	
	extract_last: function( term ){
		return this.split_list( term ).pop();
	}
	
}