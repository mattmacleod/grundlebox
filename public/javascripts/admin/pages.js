//////////////////////////////////////////////////////////////////////////////
// Grundlebox: pages.js
// 
// Handles the page tree manager
//////////////////////////////////////////////////////////////////////////////

grundlebox.admin.pages = {
	
	init: function(){
		
		// Setup the trees
		this.tree_browser.init();
		
		// Setup the page type tabs
		this.setup_page_type_tabs();
		
	},
	
	tree_browser: {
		
		init: function(){
			
			// Return unless we've got page trees
			if($(".page_tree").length===0){ return; }
			
			// Setup the JStree
			$(".page_tree").jstree({
				plugins : [ "html_data", "search" ],
				core: {
					"animation": 50
				}
			});
			
			
		}
		
	},
	
	setup_page_type_tabs: function(){
		
		// Return unless needed
		if( $(".page_forms").length===0 ){ return; }
		
		// Setup handlers on the type drop-down
		$("#page_page_type").change(this.update_page_type_tabs).change();
		
	},
	
	update_page_type_tabs: function(){
		
		// Hide all tabs
		$(".type").hide();
		
		// Show selected tab
		$("#page_type_" + $("#page_page_type").val() + "_tab").show();
		
		
	}
	
}