//////////////////////////////////////////////////////////////////////////////
// Grundlebox: tinymce.js
// 
// Handle the tinyMCE editor setup - relies on the jQuery plugin
//////////////////////////////////////////////////////////////////////////////

grundlebox.admin.tinymce = {
	
	init: function(){
		$('textarea.text_editor').tinymce({
			
					script_url : '/javascripts/tiny_mce/tiny_mce.js',

					theme : "advanced",
					plugins : "inlinepopups,searchreplace,print,contextmenu,paste,fullscreen,xhtmlxtras,grundlebox_files",
					
					width: "100%",
					height: "600px",
					
					theme_advanced_buttons1 : "bold,italic,underline,|,formatselect,|,cut,copy,paste,pastetext,pasteword,|,search,replace",
					theme_advanced_buttons2: "justifyleft,justifycenter,justifyright,|,bullist,numlist,|,undo,redo,|,link,unlink,code,|,iespell,print,fullscreen,|,image,grundlebox_files",
					theme_advanced_toolbar_location : "top",
					theme_advanced_toolbar_align : "left",
					theme_advanced_statusbar_location : "bottom",
					theme_advanced_resizing : true,

					relative_urls : false,
					
					content_css : "/stylesheets/content.css",
					valid_elements : "a[href|title|class|id],-strong/-b,-em/-i,br,-strike,-u,-sub,-sup,-p[class|style],-ul[class|style],-ol[class|style],-li[class|style],img[class|src|alt=|title|width|height|style],-h1[class|style],-h2[class|style],-h3[class|style],-h4[style],hr,span[class|style]",
					
					init_instance_callback: 'grundlebox.admin.tinymce.word_counter.init',
					
					formats : {
							alignleft   : {selector : 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes : 'align_left'},
							alignright  : {selector : 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes : 'align_right'},
							aligncenter   : {selector : 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes : 'align_center'} 
						}

			});
	},
	
	word_counter: {
		
		// Only check the counter periodically - hold a timer
		word_count_timer: null,
		counted_editor: null,
		
		// Add the callback to the tinyMCE editor instance
		init: function( editor ){
			this.counted_editor = editor;
			editor.onKeyUp.add(function(ed, e) {
				grundlebox.admin.tinymce.word_counter.count_words();
			});
		},

		// Handles the tinyMCE update event by checking to see if there's already 
		// a timer set to run. If there isn't, set one now.
		count_words: function(){
			if( this.word_count_timer === null ){
				_this = this;
				this.word_count_timer = setTimeout(_this.execute_count, grundlebox.admin.jsconfig.word_counter_timeout);
			}
		},

		// Actually execute the word count - clear the times, get the content from
		// the tinyMCE instance, and count the words. Then update the word count
		// widget to inform the user.
		execute_count: function(){
			
			// Clear the timer
			grundlebox.admin.tinymce.word_counter.word_count_timer = null;
			
			// Get the word count from the tinyMCE instance
			total_words = grundlebox.admin.tinymce.word_counter.counted_editor.getContent().split(/[\s\?]+/).length;
			
			// Update the widget
			$('.word_counter span.word_count').html( total_words );
			$('.word_counter').effect("highlight", {color: "#778"}, 1000);
		}
		
	}
	
};