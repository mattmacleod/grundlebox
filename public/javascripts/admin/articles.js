//////////////////////////////////////////////////////////////////////////////
// Grundlebox: articles.js
// 
// Handles the article manager pages - listings and forms
//////////////////////////////////////////////////////////////////////////////

grundlebox.admin.articles = {

	// Initialise the article manager JS
	init: function(){
		this.setup_publication_filter();			// Setup the publication filter
		this.setup_section_filter();					// Setup the section filter
		this.setup_article_type_chooser();		// Setup the article type widget
		this.setup_title_updater();						// Auto-update page title from form
		this.setup_show_links();							// Setup listings links to tools
		this.lock_checker.init();							// Init the article lock checker
		this.drafts.init();										// Setup draft management
	},
	
	// Changes the location to the value of the select box when the publication
	// selector is changed on the listings page
	setup_publication_filter: function(){
		$("#publication_id").change( function(){ window.location = $(this).val(); } )
	},
	
	// Changes the location to the value of the select box when the section
	// selector is changed on the listings page
	setup_section_filter: function(){
		$("#section_id").change( function(){ window.location = $(this).val(); } )
	},

	// For the article form - hide the article type subforms, only displaying 
	// selected one and updating when the selector is changed
	setup_article_type_chooser: function(){
		
		// Hide all subforms
		$(".type_options fieldset").hide();
		
		$("#article_article_type").change(function(){
			// Hide all subforms and show only the selected one
			$(".type_options fieldset").hide();
			$(".type_options fieldset#article_type_" + $(this).val() ).show();
		}).change();
		
	},
	
	// Update the title of the article form page when the content of the title
	// field in the form is changed. Sets to a single non-breaking space if empty
	// and is called on first visiting the page.
	setup_title_updater: function(){
		$("#article_title").keyup( 
			function(){
				text = $(this).val();
				if(text.length==0){ text = "(untitled)" }
				$("h1").html(text);
		}).keyup();
	},
	
	// For the listings pages - sets up the links to show articles in plain view
	// and in print view. Adds iframe to handle the latter.
	setup_show_links: function(){
		
		// Don't execute unless there's an article list.
		if( $(".search_form.articles").length==0 ){ return; }
		
		// Add the print iframe inside the body closing tag
		$("body").append("<iframe id='print_frame' name='print_frame' style='width: 0; height: 0;'></iframe>")
		
		// When the show button is clicked, just open in a new window
		$("a.article_show").live( "click", function() {
        $(this).attr("target", "_blank");
    });
		
		// When the print button is clicked, load the article into the new print
		// iframe. Then focus on it and print once it's loaded.
		$("a.article_print").live( "click", function() {
			
        $(this).attr("target", "print_frame");
			
				$("#print_frame").load( 
					function() {
						window.frames['print_frame'].focus();
						window.frames['print_frame'].print();
					}
				);
				
    });
		
	},
		
	
	// This is the lock checker. Periodically calls the check_lock method on the
	// articles controller to see if anybody else is editing the article.
	lock_checker: {
		
		// Start the lock checker, periodically calling. Only run if there is an
		// article loaded
		init: function(){
			if( $("#current_article_id").length > 0 ){
				_this = this;
				setInterval(_this.execute, grundlebox.admin.jsconfig.lock_checker_frequency )
			}
		},
	
		// Execute a lock checker iteration - load the status from the server
		// and update the notification area. Disable autosaves unless the lock 
		// belongs to the current user.
		execute: function(){
			
			var lock_check_url = "/admin/articles/" + $("#current_article_id").val() + "/check_lock";
			
			$.get(lock_check_url, function( html ){
				$("#article_lock_info").html( html );
				grundlebox.admin.articles.drafts.autosave_enabled = ( $("#lock_warning").length == 0 );
			});
			
		}
	},
	
	// Handle periodic and manual article draft saving. 
	drafts: {
		
		// Flag to indicate if we should autosave
		autosave_enabled: false,
		
		// Start the draft manager - attach the click event to the draft button
		// and set up a timer to automatically save drafts.
		init: function(){
			$("input.save_draft").click( this.save_draft );
			setInterval( 
				"if(grundlebox.admin.articles.drafts.autosave_enabled){grundlebox.admin.articles.drafts.save_draft();}",
				grundlebox.admin.jsconfig.autosave_frequency
			)
		},
		
		// Actually save a draft
		save_draft: function(){

			// Need to copy tinyMCE content into text area before we submit the form
			$("#article_content").val( tinyMCE.get('article_content').getContent() );

			// Set the button to indicate a draft is being saved
			$("input.save_draft").addClass("loading");
			$("input.save_draft").attr("value", "Saving draft...");

			// Submit the form by Ajax
			$(".edit_article").ajaxSubmit({
				
				data: { commit: "Save draft" },
				
				// When the save is complete, remove the loading state from the save
				// button and reset the text after two seconds.
				complete: function(){
					$("input.save_draft").removeClass("loading");
					setTimeout("$(\"input.save_draft\").attr('value', 'Save draft')", 2000)
				},
				
				// Update the text on the save button to indicate status.
				success: function(){
					$("input.save_draft").attr("value", "Saved!");
				},
				
				error: function(){
					$("input.save_draft").attr("value", "Failed!");
				}
				
			}); 

			return false;
		}
		
	}

}