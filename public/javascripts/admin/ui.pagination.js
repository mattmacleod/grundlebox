grundlebox.admin.ui.pagination = {
	
	timer: null,
	currentPage: 1,
	loading: false,
	enabled: true,
	
	init: function(){
		
		// Only activate if we need it
		if($("#pagination_wrapper").length==0){ return; }
			
		// Scroll event - check how far down we are, maybe request another page
		$(document).scroll(this.checkScroll)
		
		// Watch the search field
		$("#search_field").keyup(function(){
			
			this.enabled = true;
			clearTimeout(this.timer);
			$("#search_spinner").show();
			this.timer = setTimeout(grundlebox.admin.ui.pagination.submit_search, 400)
		
		});
		
	},

	submit_search: function(){
		
		$.get( location.href, { q:$("#search_field").val() }, function(html){
			if ($("#pagination_wrapper tbody").length==1){
				$("#pagination_wrapper tbody").html( html );
			} else {
				$("#pagination_wrapper").html( html );
			}
			
			$("#search_spinner").hide();
		});	
		
	},

	checkScroll:function() {
		
		_this = grundlebox.admin.ui.pagination;
		
	  if ( _this.enabled && _this.nearBottomOfPage() && !_this.loading) {
		
			_this.loading = true;
			
			$("#pagination_loading").show();
			_this.currentPage++;
	
			$.get( location.href, { page:_this.currentPage, q:$("#search_field").val() }, function(html){
				
				// Disable pagination if there were no results
				if( html.length==0 ){
					_this.enabled = false;
				} else {
					if ($("#pagination_wrapper table").length==1){
						$("#pagination_wrapper table").append( html );
					} else {
						$("#pagination_wrapper").append( html );
					}
				}
				
				_this.loading = false;
				$("#pagination_loading").hide();
				
			});
	  }
	},

	nearBottomOfPage: function() {
	  return (this.scrollDistanceFromBottom() < 700);
	},

	scrollDistanceFromBottom: function(argument) {
	  return this.pageHeight() - (window.pageYOffset + self.innerHeight);
	},

	pageHeight: function() {
	  return Math.max(document.body.scrollHeight, document.body.offsetHeight);
	}
}