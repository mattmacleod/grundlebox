grundlebox.admin.articles = {

	init: function(){
		this.setup_publication_filter();
		this.setup_section_filter();
		this.setup_article_type_chooser();
		this.setup_title_updater();
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
	}

}