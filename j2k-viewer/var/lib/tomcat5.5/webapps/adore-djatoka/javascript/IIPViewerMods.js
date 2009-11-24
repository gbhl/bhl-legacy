function getCookieVal(name){
	var charactersToStrip = ' 	';//space and tab, we'll strip these from the name of the cookie value
	var retVal = '';
	var values = document.cookie.split(";");
	for (var i=0;i<values.length;i++) {
		var pair = values[i].split("=");
		if (pair[0].replace(new RegExp("[" + charactersToStrip + "]+", "gi"),'') == name)
			retVal += pair[1];
	}
	return retVal;
}

function setCookie(name, val){
	document.cookie=name+'='+val;
}

//this is here to obfuscate a string

var sbox = new Array();
var keys = new Array();

function RC4Initialize(pwd){
	var tempSwap, a=0, b=0, intLength = pwd.length;
	for(a=97;a<=149;a++){
		keys[a] = pwd.substr((a % intLength),1).charCodeAt(0);
		sbox[a] = a;
	}

	for(a=97;a<=149;a++){
		b = (b + sbox[a] + keys[a]) % 52;
		tempSwap = sbox[a];
		sbox[a] = sbox[b];
		sbox[b] = tempSwap;
	}
	
}

function EnDeCrypt(plaintxt, pwd){
   var temp, a, i=0, j=0, k, cipherby='', cipher='';

   RC4Initialize(pwd);
   for(a = 0;a<plaintxt.length;a++){
	i = (i + 1) % 52;
	j = (j + sbox[i]) % 52;
	temp = sbox[i];
	sbox[i] = sbox[j];
	sbox[j] = temp;

	k = sbox[(sbox[i] + sbox[j]) % 52];
	cipherby = plaintxt.substr(a,1).charCodeAt(0) ^ k;
	cipher = cipher + String.fromCharCode(cipherby);
   }

   return cipher;
}

function toggleMode(){
	var mode = 'detail';
	if(document.getElementById('zoomButton').className=='magButtonIn'){
		mode = 'quick';
		document.getElementById('zoomButton').className='magButtonOut'
	}else{
		document.getElementById('zoomButton').className='magButtonIn'
	}
		
	setCookie('viewermode', mode);
	window.location.href=window.location.href.replace(/&viewermode=detail/,'').replace(/&viewermode=quick/,'')+'&viewermode='+mode;
	//alert(window.location.href.replace(/&viewermode=detail/,'').replace(/&viewermode=quick/,''));
}

var imageURL='', imageDetailURL='', cat='', image='', client='', URLToShow, viewermode = '';
var query = location.href.substring(location.href.indexOf("?")+1);

//strip off # at end of querystring it its there.
if (query.indexOf("#") > ((query.length)-2))
	query = query.substring(0,query.length-1);

var vars = query.split("&");
for (var i=0;i<vars.length;i++) {
	var pair = vars[i].split("=");

	//these are params that will be passed in most cases, for Internet Archive stuff.  Go go gadget IA!
		//get imageURL
		if (pair[0] == "imageURL")
			imageURL = pair[1];
		//get imageDetailURL
		if (pair[0] == "imageDetailURL")
			imageDetailURL = pair[1];
	
	//these are params that will be passed when imageURL and detailImageURL are now passed, mostly for botanicus stuff.
		//get cat
		if (pair[0] == "cat")
			cat = pair[1];
		//get client
		if (pair[0] == "client")
			client = pair[1];
		//get image
		if (pair[0] == "image")
			image = pair[1];


	//this if a workaround for the fact that some browsers don't like cookies within iframes
		//get image
		if (pair[0] == "viewermode")
			viewermode = pair[1];
}

//now that we have the vars we need, lets get to the task of building a querystring.  
var theActualURL = '', rawJPEG = false;

//if url/detailURL then decide whether to show detail or low res.  This will be decided based upon viewermode cookie.
var cookieVal = getCookieVal('viewermode');

//alert(cookieVal);
//here is a workaround since some browsers do not like cookies within iframes
if(cookieVal==='undefined'||cookieVal==='')
	cookieVal=viewermode;

if(cookieVal == 'detail' && imageDetailURL!=''){
	theActualURL = imageDetailURL;
}else{
	theActualURL = imageURL;
	rawJPEG = true;
}

/* 

	if clientID, cat, MARC, prefix combo then set up URI for image.  It will be high res.  
	http://images.mobot.org/{cat}/{client}/jp2/{image}
	if q string has these:
		cat=botanicus5
		client=b11631338/31753002085667/jp2
		image=31753002085667_0000.jp2
	url will be: http://us.org/botanicus5/b11932685/31753002412788/jp2/31753002412788_0001.jp2

*/
if(cat!='' && client!='' && image!=''){
	theActualURL = 'http://images.mobot.org/'+cat+'/'+client+'/'+image;


}
if(theActualURL.indexOf('.sid') != -1){//oh noes!  a MrSID image!  This new viewer no likey MrSID.
	document.write('<div style="font-size:1.4em;position:absolute;top:50px;text-align:center;width:100%;">'+
		'Oops!  The requested image is currently unavailable.<br />'+
		'We are working to restore this content.<br />'+
		'Sorry for the inconvenience.'+
		'</div>');
} else {
	// Create our viewer object - note: must assign this to the 'iip' variable
	iip = new IIP( "targetframe", server, unescape(theActualURL), '', rawJPEG );
	//set up saveimage link. we want the large JPEG if at all possible.

	if(imageURL!=''){
		if(imageDetailURL!='')
			window.addEvent( 'domready', function(){document.getElementById('saveImageButton').href="http://images.mobot.org/viewer/saveimage.asp?imageURL="+imageURL+"&imageDetailURL="+imageDetailURL; } );
		else
			window.addEvent( 'domready', function(){document.getElementById('saveImageButton').href="http://images.mobot.org/viewer/saveimage.asp?imageURL="+imageURL+"&imageDetailURL="+theActualURL; } );
	} else {
		window.addEvent( 'domready', function(){
			document.getElementById('saveImageButton').href="http://images.mobot.org/viewer/saveimage.asp?imageDetailURL="+theActualURL+"&imageURL=";
		} );
	}
	
	
	//set up print link. we want the large JPEG if at all possible.
	if(imageURL!='')
		window.addEvent( 'domready', function(){document.getElementById('printImageButton').href="viewerPrint.jsp?imageURL="+unescape(imageURL); } );
	else
		window.addEvent( 'domready', function(){document.getElementById('printImageButton').href="viewerPrint.jsp?imageURL=";} );

}
