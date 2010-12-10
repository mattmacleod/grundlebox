grundlebox.admin.articles = {

	init: function(){
		this.setup_publication_filter();
		this.setup_section_filter();
		this.setup_article_type_chooser();
		this.setup_title_updater();
		this.setup_show_links();
	},
	
	setup_publication_filter: function(){
		$("#publication_id").change(function(){
			window.location = $(this).val();
		})
	},
	
	setup_section_filter: function(){
		$("#section_id").change(function(){
			window.location = $(this).val();
		})
	},

	setup_article_type_chooser: function(){
		$(".type_options fieldset").hide();
		$("#article_article_type").change(function(){
			$(".type_options fieldset").hide();
			$(".type_options fieldset#article_type_"+$(this).val()).show();
		}).change();
	},
	
	setup_title_updater: function(){
		$("#article_title").keyup(function(){
			text = $(this).val();
			if(text.length==0)
				text="&nbsp;"
			$("h1").html(text);
		});
	},
	
	setup_show_links: function(){
		
		if( $("a.article_print,a.article_show").length==0 ){ return; }
		
		$("body").append("<iframe id='print_frame' name='print_frame' style='width: 0; height: 0;'></iframe>")
		
		$("a.article_show").click( function() {
        $(this).attr("target", "_blank");
    });
		
		$("a.article_print").click( function() {
        $(this).attr("target", "print_frame");
				$("#print_frame").load( 
					function() {
						window.frames['print_frame'].focus();
						window.frames['print_frame'].print();
					}
				);
    });
		
	}

}