//////////////////////////////////////////////////////////////////////////////
// Grundlebox: login_page.js
// 
// Handles login page
//////////////////////////////////////////////////////////////////////////////

grundlebox.admin.login_page = {
	
	init: function(){
		
		// Return unless we're on the login page
		if( $("fieldset.login").length===0 ){ return; }
		
		// Hide the JS warning
		$(".noscript").hide();
		
		$(".script").show();
	}
	
}