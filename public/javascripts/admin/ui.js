grundlebox.admin.ui = {
	
	// Setup the UI elements across the admin
	init: function(){
		this.setup_flash();
		this.pagination.init();
		this.setup_tabbed_forms();
	},
	
	// Handle effects etc for the flash message
	setup_flash: function(){
		
		// Do the highlight effect
		$(".flash_wrapper").children().effect('flash_highlight', 1000);

		// Click to close
		$(".flash_wrapper").click(
			function(e){
				$(this).children().css("background-image", "none");
				$(this).children().hide("blind", 500);
				$(this).hide("blind", 500);
				return false;
			}
		);
		
	},
	
	setup_tabbed_forms: function(){
		if($(".tabbed_fieldsets").length==0){ return; }
		$(".tabbed_fieldsets").addClass("tabs_enabled")
		$(".tabbed_fieldsets ul.tabs").tabs(".tabbed_fieldsets > fieldset")
		$(".tabbed_fieldsets > fieldset").each(function(){
			if($(this).find(".field_with_errors").length>0){
				$(this).parent().find("a[href=#"+$(this).attr("id")+"]").addClass("has_error");
			}
		});
	}
	
}