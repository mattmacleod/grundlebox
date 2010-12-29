//////////////////////////////////////////////////////////////////////////////
// Grundlebox: admin.js
// 
// This javascript file handles the main admin startup
//////////////////////////////////////////////////////////////////////////////

grundlebox = { 
	admin: {
		
		// Main init function for Grundlebox admin interface
		init: function(){
			this.ui.init();							// User interface elements
			this.tinymce.init();				// Rich text editor
			this.articles.init();				// Article editor tools
			this.venues.init();					// Venue manager bits 
			this.tagging.init();				// Tagging
			this.asset_manager.init();	// Asset manager
		},

		// Set some config variables here
		jsconfig: {
			lock_checker_frequency: 15000,
			autosave_frequency: 60000,
			word_counter_timeout: 2000,
			paginated_search_timeout: 400
		}
		
	}
}

$(document).ready(function(){
	grundlebox.admin.init();	
});