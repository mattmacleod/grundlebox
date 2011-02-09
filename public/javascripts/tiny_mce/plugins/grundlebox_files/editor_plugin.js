(function() {

	tinymce.PluginManager.requireLangPack('grundlebox_files');

	tinymce.create('tinymce.plugins.GrundleboxFilesPlugin', {

		init : function(ed, url) {

			ed.addCommand('grundleboxFiles', function() {
				
				// Get the selection in the current editor and configure the plugin.
				// We assume Grundlebox admin is always at /admin
				var current_editor_selection = ed.selection;
				var selected_node = current_editor_selection.getNode();
				var selected_node_parent = $(selected_node).parent()[0];
				var target_href = "/admin/asset_folders/attach";
				var is_managed = true;
				var image_regex = /[\d]+\/[\d]+\_\/.+\./i;
				
				// Store the selected area
				grundlebox.admin.asset_manager.attachment.stored_selection = current_editor_selection.getBookmark();
				
				// Is the selected item an image? Extract it out and get the filename
				// and other attributes. Also store the link if there is one of those.
				if (selected_node.nodeName == 'IMG') {
					
					// The selected node is an image - try to get the Grundlebox id
					// of the file by looking at the address
					file_id = ( ( selected_node_parent.href && selected_node_parent.href.match(image_regex) ) || ( selected_node.src.match(image_regex) ) );
					
					if ( file_id ) {
						
						// This is a managed file, so build the URL of the image management
						// page that we need to access
						target_href = "/admin/assets/" + file_id[1];
						
						// Get the filename out of the attached img tag's source attr
						var filename = selected_node.src.match(/([a-z0-9_\.-]+)$/i);
						
						// Save the details of the embedded image into the JS asset manager object
						if ( filename ) {
							grundlebox.admin.asset_manager.attachment.active_filename = filename[1];
							grundlebox.admin.asset_manager.attachment.properties['alignment'] = selected_node_parent ? selected_node_parent.className : selected_node.className;
							grundlebox.admin.asset_manager.attachment.properties['width'] = selected_node.width;
							grundlebox.admin.asset_manager.attachment.properties['height'] = selected_node.height;
							grundlebox.admin.asset_manager.attachment.properties['title'] = selected_node_parent ? selected_node_parent.title : selected_node.title;
							
							// If the parent node is a link, we'll need to store the href
							// too so we can pick it up later
							if (selected_node_parent.nodeName == 'A') {
								grundlebox.admin.asset_manager.attachment.properties['link_to_original'] = selected_node_parent.href.replace(/http[s://]+[^/]+/gi,'');
							}
							
						}
						
					} else {
						
						// This doesn't appear to be a managed image.
						is_managed = false;
						
					}
					
				} else if (selected_node.nodeName == 'A') {
					
					// The node is a link to a file - see if it's managed
					
					if ( file_id = selected_node.href.match(/([a-z0-9_\.-]+)$/i) ) {
						href = "/admin/assets/" + file_id[1];
						grundlebox.admin.asset_manager.attachment.properties['title'] = e.title;
					} else {
						is_managed = false;
					}
				}
				
				
				if( is_managed ) {
					
					// Editing a managed file - Add Pretty Photo popup details here
					target_href += "?popup=true&iframe=true&width=850&height=" + (document.documentElement.clientHeight - 100)
					
					grundlebox.admin.asset_manager.attachment.editor_select = true;
					$.prettyPhoto.open( target_href );
					
				} else {
					return
				}
				
			});

			// Add the GB file selector button
			ed.addButton('grundlebox_files', {
				title : 'grundlebox_files.desc',
				cmd : 'grundleboxFiles',
				image : url + '/img/picture.gif'
			});

			ed.onNodeChange.add(function(ed, cm, n, co) {
				cm.setActive('grundlebox_files', n.nodeName == 'IMG');
			});
		},

		createControl : function(n, cm) {
			return null;
		},

		getInfo : function() {
			return {
				longname 	: 'Grundlebox file manager plugin',
				author 		: 'Matthew MacLeod',
				authorurl : 'http://www.grundlebox.co.uk',
				infourl 	: 'http://www.grundlebox.co.uk',
				version 	: "1.0"
			};
		}
	});

	tinymce.PluginManager.add('grundlebox_files', tinymce.plugins.GrundleboxFilesPlugin);
	
})();