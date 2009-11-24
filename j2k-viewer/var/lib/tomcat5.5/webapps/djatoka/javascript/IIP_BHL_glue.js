/**
	@author: Chris Moyers
	@description: this is a glue layer for BHL to IIP viewer.  Since BHL currently passes in several params that are specialized for BHL stuff,
		this script constructs the appropriate params to pass to the IIP viewer, which in turn passes this to Djatoka.
	@date: 3/13/2009

*/

var the_url='',imageURL='',imageDetailURL='',cat='',client='',image='';

//split apart the querystring
var query = location.href.substring(location.href.indexOf('?')+1);
var vars = query.split("&");
for (var i=0;i<vars.length;i++) {
	var pair = vars[i].split("=");

	//url.  Preferred method.  Should just be a URL to an image.  Perhaps down the road it will be a more concise URI?
		//get url
		if (pair[0] == "url")
			the_url = pair[1].trim();

	//these are params for Internet Archive stuff. 
		//get imageURL
		if (pair[0] == "imageURL")
			imageURL = pair[1].trim();
		//get imageDetailURL
		if (pair[0] == "imageDetailURL")
			imageDetailURL = pair[1].trim();
	
	//these are params that will be passed mostly for botanicus stuff.
		//get cat
		if (pair[0] == "cat")
			cat = pair[1].trim();
		//get client
		if (pair[0] == "client")
			client = pair[1].trim();
		//get image
		if (pair[0] == "image")
			image = pair[1].trim();
}

//if we didn't get an url, then we need to use pther params that might have been passed in.
if (the_url==''){
	if(cat.toLowerCase()=="researchimages")
		cat = "TropicosImages1";
		
	//build the_url from botanicus params
	if(cat!='' && client!='' && image!='')
		the_url = 'http://mbgserv09:8057/'+cat+'/'+client+'/'+image;

	//get the_url imageURL if there is no detailimageURL, mostly for MOBOT rare books
	if(imageURL!=''){
		the_url = imageURL;
	}
	
	//get the_url imageDetailURL (most commonly this wil lbe supplied)
	if(imageDetailURL!=''){
		the_url = imageDetailURL;
	}
}
