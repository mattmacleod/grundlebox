//////////////////////////////////////////////////////////////////////////////
// Grundlebox: admin.js
// 
// This javascript file handles the main admin startup
//////////////////////////////////////////////////////////////////////////////

grundlebox = { 
	admin: {
		
		// Main init function for Grundlebox admin interface
		init: function(){
			this.login_page.init();			// Login page JS
			this.ui.init();							// User interface elements
			this.tinymce.init();				// Rich text editor
			this.articles.init();				// Article editor tools
			this.venues.init();					// Venue manager bits 
			this.tagging.init();				// Tagging
			this.asset_manager.init();	// Asset manager
			this.events.init();					// Event manager
		},

		// Set some config variables here
		jsconfig: {
			lock_checker_frequency: 15000,	// 15 seconds
			autosave_frequency: 30000,			// 30 seconds
			word_counter_timeout: 2000,			// 2 seconds
			paginated_search_timeout: 400		// 0.4 seconds
		}
		
	}
}

$(document).ready(function(){
	grundlebox.admin.init();	
});