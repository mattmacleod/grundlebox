Array.prototype.unique = function(){
	
	var new_array = [];
	var index = 0;
	
	for(var count=0; count < this.length; count++){
		
		var value = this[count];
		
		if( new_array.indexOf(value)==-1 ){
			new_array[index++] = value;
		}
		
	}
	
	return new_array;
	
}