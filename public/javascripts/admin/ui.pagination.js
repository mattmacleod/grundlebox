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
			$("#pagination_wrapper tbody").html( html );
			$("#search_spinner").hide();
		});	
		
	},

	checkScroll:function() {

	  if ( this.enabled && this.nearBottomOfPage() && !this.loading) {
		
			this.loading = true;
			
			$("#pagination_loading").show();
			this.currentPage++;
	
			$.get( location.href, { page:this.currentPage, q:$("#search_field").val() }, function(html){
				
				// Disable pagination if there were no results
				if( html.length==0 ){
					this.enabled = false;
				} else {
					$("#pagination_wrapper table").append(html);
				}
				
				this.loading = false;
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