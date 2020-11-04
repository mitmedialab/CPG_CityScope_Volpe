model citIOGAMA
// Example of a model that uses GAMABrix to connect to cityio. 

import "GAMABrix.gaml"
global {
	string city_io_table<-"dungeonmaster";
	
	// It'd be great to also move the following two lins of code to the other file
	file geogrid <- geojson_file("https://cityio.media.mit.edu/api/table/"+city_io_table+"/GEOGRID","EPSG:4326");
	geometry shape <- envelope(geogrid);
	
	int update_frequency<-10;
	bool forceUpdate<-true;

	init {
		create people with:(att1:rnd(10),att2:rnd(10)) number:5; // For now, people are imported from GAMABrix, because the current version of cityio_heatmap_indicator needs the people species. 
		create cityio_numeric_indicator with: (viz_type:"bar",indicator_name: "Mean Height", indicator_value: "mean(block collect each.height)");
		create cityio_numeric_indicator with: (viz_type:"bar",indicator_name: "Min Height",  indicator_value: "min(block collect each.height)");
		create cityio_numeric_indicator with: (viz_type:"bar",indicator_name: "Max Height",  indicator_value: "max(block collect each.height)");
		create my_cool_indicator        with: (viz_type:"bar",indicator_name: "Number of blocks");
		create cityio_heatmap_indicator with: (listOfPoint:list<people>(people));
	}
}

// Example of how a user would define their own numeric indicator
species my_cool_indicator parent: cityio_numeric_indicator {
	// Users might want more complex indicators that cannot be constructed by passing indicator to the constructor for cityio_numeric_indicator 
	float return_indicator {
		return length(block);
	}
}


experiment CityScope type: gui autorun:false{
	output {
		display map_mode type:opengl background:#black{	
			species block aspect:base;
			species people aspect:base position:{0,0,0.1};
		}
	}
}