grundlebox.admin.articles = {

	init: function(){
		this.setup_publication_filter();
		this.setup_section_filter();
		this.setup_article_type_chooser();
		this.setup_title_updater();
		this.setup_show_links();
		this.lock_checker.init();
	},
	
	setup_publication_filter: function(){
		$("#publication_id").change(function(){
			window.location = $(this).val();
		})
	},
	
	setup_section_filter: function(){
		$("#section_id").change(function(){
			window.location = $(this).val();
		})
	},

	setup_article_type_chooser: function(){
		$(".type_options fieldset").hide();
		$("#article_article_type").change(function(){
			$(".type_options fieldset").hide();
			$(".type_options fieldset#article_type_"+$(this).val()).show();
		}).change();
	},
	
	setup_title_updater: function(){
		$("#article_title").keyup(function(){
			text = $(this).val();
			if(text.length==0)
				text="&nbsp;"
			$("h1").html(text);
		});
	},
	
	setup_show_links: function(){
		
		if( $(".search_form.articles").length==0 ){ return; }
		
		$("body").append("<iframe id='print_frame' name='print_frame' style='width: 0; height: 0;'></iframe>")
		
		$("a.article_show").live( "click", function() {
        $(this).attr("target", "_blank");
    });
		
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
	
	
	// This is inited through the tinymce loader
	word_counter: {
		
		word_count_timer: null,

		init: function( editor ){
			_this = this;
			editor.onKeyUp.add(function(ed, e) {
		        _this.count_words();
		    });
		},

		count_words: function(){
			if( this.word_count_timer==null ){
				_this = this;
				this.word_count_timer = setTimeout(_this.execute_count, 1000);
			} else {
				return
			}
		},

		execute_count: function(){
			grundlebox.admin.articles.word_counter.word_count_timer = null;
			total_words = tinyMCE.get( 'article_content' ).getContent().split(/[\s\?]+/).length;
			$('.word_counter span.word_count').html(total_words);
			$('.word_counter').effect("highlight", {color: "#778"}, 1000);
		}
		
	},
	
	
	lock_checker: {
		
		init: function(){
			if( $("#current_article_id").length > 0 ){
				_this = this;
				setInterval(_this.execute, (5000))
			}
		},
	
		execute: function(){
			
			$.get( "/admin/articles/" + $("#current_article_id").val() + "/check_lock", function(html){
				$("#article_lock_info").html( html );
				this.autosave_enabled = ($("#lock_warning").length == 0);
			});
		}
	}

}