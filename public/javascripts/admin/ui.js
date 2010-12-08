grundlebox.admin.ui = {
	
	// Setup the UI elements across the admin
	init_ui_elements: function(){
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
		$(".tabbed_fieldsets").addClass("tabs_enabled")
		$(".tabbed_fieldsets ul.tabs").tabs(".tabbed_fieldsets > fieldset")
	}
	
}