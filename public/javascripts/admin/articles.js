grundlebox.admin.articles = {

	init: function(){
		this.setup_publication_filter();
		this.setup_section_filter();
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
	}

}