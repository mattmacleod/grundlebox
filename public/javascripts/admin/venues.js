grundlebox.admin.venues = {
	
	venue_marker: null,
	
	init: function(){
		
		if($("#venue_map_area").length==0){ return; }
		
		this.load_google_maps();
		
	},
	
	load_google_maps: function(){
		
		google.load("maps", "2", {"callback" : grundlebox.admin.venues.set_initial_map_location});
			
	},
	
	set_initial_map_location: function(){
		
		// Set up a resizing hook!
		$("a[href=#location]").click( function(){
		
			// Try to use latitude and logitude if they exist, otherwise get the defaults
			var initial_location = {
				latitude: $("#grundlebox_default_map_location").html().split(",")[0],
				longitude: $("#grundlebox_default_map_location").html().split(",")[1],
				depth: 5
			}
				
			if( !$("#venue_lat").val()=="" ){
				initial_location =  {
					latitude: $("#venue_lat").val(),
					longitude: $("#venue_lng").val(),
					depth: 14
				}
				var has_marker = true;
			}
		
			$("#venue_map_area").googleMaps(initial_location);
		
			// If there are no markers, then we have to set things up so an initial 
			// click will create one
			if( !has_marker ){
						
				event_listener = GEvent.addListener($.googleMaps.gMap, "click", function(overlay, latlng) {
				  marker = new GMarker(latlng, {draggable: true});
					grundlebox.admin.venues.venue_marker = marker;
					$.googleMaps.gMap.addOverlay(marker);
					grundlebox.admin.venues.update_venue_location_fields( latlng )
					GEvent.addListener(marker, "dragend", function( newlatlng ) { grundlebox.admin.venues.update_venue_location_fields(newlatlng) });
					GEvent.removeListener(event_listener);
				});
			
			} else {
				 marker = new GMarker(new GLatLng(initial_location.latitude, initial_location.longitude), {draggable: true});
				grundlebox.admin.venues.venue_marker = marker;
				$.googleMaps.gMap.addOverlay(this.venue_marker);
				GEvent.addListener(this.venue_marker, "dragend", function( newlatlng ) { grundlebox.admin.venues.update_venue_location_fields(newlatlng) });
			}
		
			// Add change handlers to lat and lng
			$("#venue_lat,#venue_lng").keyup(function(){
				grundlebox.admin.venues.update_marker_location($("#venue_lat").val(), $("#venue_lng").val());
			});
			
		});
		
		
	},
	
	update_venue_location_fields: function( latlng ){
		$("#venue_lat").val( latlng.lat() );
		$("#venue_lng").val( latlng.lng() );
	},
	
	update_marker_location: function( lat, lng ){
		if( this.venue_marker ){
			this.venue_marker.setLatLng( new GLatLng(lat, lng) )
		} else {			
			marker = new GMarker(new GLatLng(lat, lng), {draggable: true});
			this.venue_marker = marker;
			$.googleMaps.gMap.addOverlay(marker);
			GEvent.addListener(marker, "dragend", function( newlatlng ) { grundlebox.admin.venues.update_venue_location_fields(newlatlng) });
		}
	}
	
	
}