grundlebox.admin.ui = {
	
	// Setup the UI elements across the admin
	init_ui_elements: function(){
		this.setup_flash();
		this.pagination.init();
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
		
	}
	
}