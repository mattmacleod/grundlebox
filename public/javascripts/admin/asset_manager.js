//////////////////////////////////////////////////////////////////////////////
// Grundlebox: asset_manager.js
// 
// Handles the asset manager pages
//////////////////////////////////////////////////////////////////////////////

grundlebox.admin.asset_manager = {
	
	// Setup the asset manager
	init: function(){
		this.setup_folder_browser();		// Setup the treeview on the browser
		this.setup_pp();								// Setup the image preview box
		this.pagination.init();					// Setup the special-case pagination
	},
	
	// Sets up the treeview for the folder browser using the jQuery treeview
	// plugin.
	setup_folder_browser: function(){
		$(".asset_folder_list").treeview({ animated: "fast" })
	},
	
	setup_pp: function(){
		$(".pp_pic_holder").remove();
		$(".pp_overlay").remove();
		$(".ppt").remove();
		$("a[rel^='prettyPhoto']").prettyPhoto({theme: "dark_rounded"});
	},

	// Handles custom pagination for the asset browser. Copied from the main 
	// pagination JS. I know I should make it modular, but you know what they
	// say: first time, don't write for the general case. Second time, think 
	// about how you might modularise it in the future. Third time, refactor.
	// I think I fulfilled the second step!
	pagination: {
		
		timer:null,
		currentPage: 1,
		loading: false,
		enabled: true,
		
		init: function(){
			
			if( $("#main_folder_wrapper" ).length==0){ return; }
			
			$(document).scroll( this.checkScroll );
			
			var _this = this;
			$("#search_field").keyup(function(){
				_this.enabled = true;
				clearTimeout(_this.timer);
				$("#search_spinner").show();
				_this.timer = setTimeout(_this.submit_search, 400)
			});
			
		},

		submit_search: function(){
			
			$.get( location.href , { q:$("#search_field").val() }, function(html){
				$("#main_folder_wrapper").html( html );
				$("#search_spinner").hide();
				grundlebox.admin.asset_manager.setup_pp();
			});	
			
		},

		checkScroll:function() {

		_this = grundlebox.admin.asset_manager.pagination;
			
		  if (_this.enabled && _this.nearBottomOfPage() && !_this.loading) {
						
				_this.loading = true;
				
				$("#pagination_loading").show();
		    _this.currentPage++;
		
		    $.get( 
					location.href,
					{ page: _this.currentPage, q: $("#search_field").val() }, 
					function(html){
					
						// Disable pagination if there were no results
						if(html.length==0){
							_this.enabled = false;
						} else {
							$("#main_folder_wrapper").append( html );
							grundlebox.admin.asset_manager.setup_pp();
						}
					
						_this.loading = false;
						$("#pagination_loading").hide();
					
				});
		  }
		
		},

		nearBottomOfPage: function() {
		  return (_this.scrollDistanceFromBottom() < 500);
		},

		scrollDistanceFromBottom: function(argument) {
		  return _this.pageHeight() - (window.pageYOffset + self.innerHeight);
		},

		pageHeight: function() {
		  return Math.max(document.body.scrollHeight, document.body.offsetHeight);
		}
	}
};