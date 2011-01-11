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
			if($("#page_tree").length===0){ return; }
			
			// Setup the JStree
			this.setup_tree();
			
			// Setup search handler
			// Watch the search field for updates and submit search
			$("#pages_search_field").keyup(function(){

				clearTimeout(this.timer);
				$("#search_spinner").show();

				// Submit the search after a short delay (i.e. only submit a search a
				// short while after the user has stopped typing)
				this.timer = setTimeout(grundlebox.admin.pages.tree_browser.do_search, grundlebox.admin.jsconfig.paginated_search_timeout)
				
			});
						
		},
		
		setup_tree: function(){
			
			// Execute jstree
			$("#page_tree").jstree({
				plugins : [ "html_data", "search", "dnd", "CRRM" ],
				core: {
					animation: 50
				},
				search: {
					case_insensitive: true
				},
				dnd: {
					copy_modifier: null
				}
			});
			
			// Setup drag events
			_this = this;
			$("#page_tree").bind("check_move.jstree", function(){ console.log("test")})
			
			$("#page_tree").bind("move_node.jstree", _this.handle_reorder)
			
		},
		
		// The handler for actually submitting a search from the search box
		do_search: function(){
						
			// Hide the spinner
			$("#search_spinner").hide();
			
			// Actually do the search
			$("#page_tree").jstree( "search", $("#pages_search_field").val() );
			
			// If we're searching for an empty string, then remove the search
			// class, otherwise add it...
			if( $("#pages_search_field").val()=="" ){
				$("#page_tree").removeClass("searching")
			} else {
				$("#page_tree").addClass("searching")
			}
			
		},
		
		handle_reorder: function(d,e){
			
			// Get the essential details
			var moving_id = e.args[0].o.attr("id").replace("page_node_", "");
			var parent_id = e.args[0].np.attr("id").replace("page_node_", "");
			var cp = e.args[0].cp;
			
			// Send the attributes
			$.ajax( 
				{	
					url: "/admin/pages/update_order", 
					type: "POST",
					data: { _method: "put", m: moving_id, p: parent_id, s: cp },
					complete: function(e,f){
						$("#page_list_wrapper").html( e.responseText );
						grundlebox.admin.pages.tree_browser.setup_tree();
						if( f=="error" ){							
							alert("Error updating page structure.");
						}
						
					}
				}
			);	
			
			// Open all nodes
			$("#page_tree").jstree("open_all");
			
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