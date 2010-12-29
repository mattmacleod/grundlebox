grundlebox = { 
	admin: {
		
		// Main init function for Grundlebox admin interface
		init: function(){
			this.ui.init();				// User interface elements
			this.tinymce.init();	// Rich text editor
			this.articles.init();	// Article editor tools
			this.venues.init();		// Venue manager bits 
			this.tagging.init();	// Tagging
		}
		
	}
}

$(document).ready(function(){

	grundlebox.admin.init();
	
});