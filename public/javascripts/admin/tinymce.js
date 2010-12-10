grundlebox.admin.tinymce = {
	
	init: function(){
		$('textarea.text_editor').tinymce({
			
					script_url : '/javascripts/tiny_mce/tiny_mce.js',

					theme : "advanced",
					plugins : "inlinepopups,searchreplace,print,contextmenu,paste,fullscreen,xhtmlxtras",
					
					width: "100%",
					height: "600px",
					
					theme_advanced_buttons1 : "bold,italic,underline,|,formatselect,|,cut,copy,paste,pastetext,pasteword,|,search,replace",
					theme_advanced_buttons2: "bullist,numlist,|,undo,redo,|,link,unlink,code,|,iespell,print,fullscreen",
					theme_advanced_buttons3: "",
					theme_advanced_toolbar_location : "top",
					theme_advanced_toolbar_align : "left",
					theme_advanced_statusbar_location : "bottom",
					theme_advanced_resizing : true,

					content_css : "/stylesheets/content.css",

					init_instance_callback: 'grundlebox.admin.articles.word_counter.init'

			});
	}
}