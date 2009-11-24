/*
	IIPImage Javascript Viewer <http://iipimage.sourceforge.net>
					Version 1.0

	Copyright (c) 2007 Ruven Pillay <ruven@users.sourceforge.net>

	Built using the Mootools javascript framework <http://www.mootools.net>

	---------------------------------------------------------------------------

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

	---------------------------------------------------------------------------

	Example:

	iip = new IIP( 'div_id', 'http://www.server.com/fcgi-bin/iipsrv.fcgi', '/images/test.tif', 'copyright me 2007' );

	where the arguments are:

	i) The id of the main div element in which to create the viewer window
	ii) The iipsrv server full URL
	iii) The full image path on the server
	iv) An optional image copyright or information

	Note: The new class instance must be assigned to the global variable "iip" in this version.
		: Requires mootools version 1.1 <http://www.mootools.net>
		: The page must have a standard-compliant XHTML declaration at the beginning




	This script has been modified somewhat by Chris Moyers for the Biodiversity Heritage Library to display JPEG images tiles by djatoka.
	Since the BHL has a significant quantity of JPEGs, and we want to use a consistent delivery mechanism, we are piping a few large JPEGs through
	djatoka and this viewer.  Djatoka tiles JPEGs just as it does with JPG2000 images, but displaying them is handled a bit differently.  Also, 
	I did some cleanup on the code to make it more readable/smaller.

*/

// Global instance of our IIP object for use by the TargetDrag class
var iip;

/* Create our own class inherited from Drag.Move for constrained dragging of
	the main target window

*/
var TargetDrag = Drag.Move.extend({

	initialize: function(el, options){
		this.setOptions(options);
		this.element = $(el);
		this.handle = $(this.options.handle) || this.element;
		this.mouse = {'now': {}, 'pos': {}};
		this.value = {'start': {}, 'now': {}};
		this.bound = {
		'start': this.start.bindWithEvent(this),
		'check': this.check.bindWithEvent(this),
		'drag': this.drag.bindWithEvent(this),
		'stop': this.stop.bind(this)
		};
		this.attach();
		if (this.options.initialize) this.options.initialize.call(this);

	},

	drag: function(event){
		this.out = false;
		this.mouse.now = event.page;
		for (var z in this.options.modifiers){
		if (!this.options.modifiers[z]) continue;
		this.value.now[z] = this.mouse.now[z] - this.mouse.pos[z];

		if( z == 'x' ){
			if( iip.rgn_x - this.value.now[z] < 0 ){
			this.value.now[z] = iip.rgn_x;
			this.out = true;
			}
			if( iip.wid > iip.rgn_w ){
			if( iip.rgn_x - this.value.now[z] > iip.wid - iip.rgn_w ){
				this.value.now[z] = -(iip.wid - iip.rgn_w - iip.rgn_x);
				this.out = true;
			}
			}
			else{
			this.value.now[z] = 0;
			this.out = true;
			}
		}
		if( z == 'y' ){
			if( iip.rgn_y - this.value.now[z] < 0 ){
			this.value.now[z] = iip.rgn_y;
			this.out = true;
			}
			if( iip.hei > iip.rgn_h ){
			if( iip.rgn_y - this.value.now[z] > iip.hei - iip.rgn_h ){
				this.value.now[z] = -(iip.hei - iip.rgn_h - iip.rgn_y);
				this.out = true;
			}
			}
			else{
			this.value.now[z] = 0;
			this.out = true;
			}
		}

		this.element.setStyle(this.options.modifiers[z], this.value.now[z] + this.options.unit);
		}
		this.fireEvent('onDrag', this.element);
		event.stop();
	}

});

/* IIP Javascript Class

*/
var IIP = new Class({

	/* Initialize some variables. The constructor takes 4 arguments:
	i) The id of the main div element in which to create the viewer window
	ii) The iipsrv server full URL
	iii) The full image path on the server
	iv) An optional image copyright or information
	*/
	initialize: function( main_id, server, image, credit, rawJPEG ) {

		this.source = main_id;
		this.server = server;
		this.fif = image;
		this.max_width = 0;
		this.max_height = 0;
		this.min_x = 0;
		this.min_y = 0;
		this.sds = "0,90";
		this.contrast = 1.0;
		this.wid = 0;
		this.hei = 0;
		this.rgn_x = 0;
		this.rgn_y = 0;
		this.rgn_w = this.wid;
		this.rgn_h = this.wid;
		this.xfit = 0;
		this.yfit = 0;
		this.navpos = [0,0];
		this.tileSize = [0,0];
		this.resolution;
		this.refresher = null;
		this.credit = credit;
		this.init = false;

		// djatoka vars
		this.max_zoom =7;
		this.top_left_x = 0;
		this.top_left_y = 0;
		this.svc_val_fmt = "info:ofi/fmt:kev:mtx:jpeg2000";
		this.svc_id = "info:lanl-repo/svc/getRegion";
		this.openUrl;

		//bhl vars
		this.rawJPEG = rawJPEG;
		this.middleRes = 3;

		/* Load us up when the DOM is fully loaded!
		*/
		window.addEvent( 'domready', function(){ this.load() }.bind(this) );

	},

	/*
	Create the appropriate CGI strings and change the image sources
	*/
	requestImages: function() {

		// Clear our tile refresher
		if( this.refresher ){
			$clear( this.refresher );
			this.refresher = null;
		}

		// Set our cursor and activate our loading animation
		$('target').style.cursor = 'wait';
		$('loading2').setOpacity(1);
		$('loading2').style.zIndex = '2';

		// Load our image mosaic
		this.loadGrid();

		// Create a tile refresher to check for unloaded tiles
		//this.refresher = this.refresh.periodical( 500, this );
		// djatoka - Delay the refresh interval
		this.refresher = this.refresh.periodical( 1200, this );

	},

	/* Create a grid of tiles with the appropriate JTL request and positioning
	*/
	loadGrid: function(){

		// Delete our old image mosaic
		$('target').getChildren().each( function(el){ el.remove(); } );
		$('target').setStyles({
			left: '0px',
			top: '0px'
		});

		// Get the start points for our tiles
		var startx = Math.floor( this.rgn_x / this.tileSize[0] );
		var starty = Math.floor( this.rgn_y / this.tileSize[1] );

		// If our size is smaller than the display window, only get these tiles!
		var len = this.rgn_w;
		if( this.wid < this.rgn_w ) len = this.wid;
		var endx =  Math.floor( (len + this.rgn_x) / this.tileSize[0] );

		len = this.rgn_h;
		if( this.hei < this.rgn_h ) len = this.hei;
		var endy = Math.floor( (len + this.rgn_y) / this.tileSize[1] );

		// Number of tiles is dependent on view width and height
		var xtiles = Math.ceil(this.wid / this.tileSize[0]);
		var ytiles = Math.ceil(this.hei / this.tileSize[1]);

		/* Calculate the offset from the tile top left that we want to display.
			Also Center the image if our viewable image is smaller than the window
		*/
		var xoffset = Math.floor(this.rgn_x % this.tileSize[0]);
		//if( this.wid < this.rgn_w ) xoffset -=  (this.rgn_w - this.wid)/2;

		var yoffset = Math.floor(this.rgn_y % this.tileSize[1]);
		//if( this.hei < this.rgn_h ) yoffset -= (this.rgn_h - this.hei)/2;

		var tile;
		var i, j, k;
		var left, top;
		//k = 0;

		// init djatoka grid logic
		var f = this.tileSize[0];
		var r = this.max_zoom - this.resolution;
		f = this.getMultiplier(r,f);
		var first = true;
		//alert(f+":"+ starty+":"+endy+":"+startx+":"+endx+":");
		// Create our image tile mosaic
		for( j=starty; j<=endy; j++ ){
			for( i=startx; i<=endx; i++ ){
				// djatoka is based of the offset value of the max resolution, so we need to apply the multiplier
				var l = i * f;
				var t = j * f;
				//alert(l+':'+t);
				if (first) {
					top_left_x = (l + this.getMultiplier(r,xoffset-2));
					top_left_y = (t + this.getMultiplier(r,yoffset-2));
					if (top_left_x < 0)
						top_left_x = 0;
					if (top_left_y < 0)
						top_left_y = 0;
					this.setOpenURL();
					first = false;
				}

				var src = this.server + "?url_ver=Z39.88-2004&rft_id=" + this.fif + "&svc_id=" + this.svc_id + "&svc_val_fmt=" + this.svc_val_fmt + "&svc.format=image/jpeg&svc.level=" + this.resolution + "&svc.rotate=0&svc.region=" + t + "," + l + "," + this.tileSize[1] + "," + this.tileSize[0];
			tile = new Element('img', {
					'src': src,
					'styles': {
				'left': (i-startx)*this.tileSize[0] - xoffset,
					'top': (j-starty)*this.tileSize[1] - yoffset
				}
		});
		tile.injectInside('target');
			}
		}

	},

	/* djatoka is based of the offset value of the max resolution,
	so we need to apply the multiplier
	*/
	getMultiplier: function( r, f ){
		var m = f;
		for (i=0;i<r;i++) {
				m = m * 2;
		}
		return m;
	},

	/* Refresh function to avoid the problem of tiles not loading
	properly in Firefox/Mozilla
	*/
	refresh: function(){

		var unloaded = 0;

		$('target').getChildren().each( function(el){
			// If our tile has not yet been loaded, give it a prod ;-)
			if( el.width == 0 || el.height == 0 ){
		el.src = el.src;
		unloaded = 1;
			}
		});

		/* If no tiles are missing, destroy our refresher timer, fade out our loading
			animation and and reset our cursor
		*/
		if( unloaded == 0 ){

			$clear( this.refresher );
			this.refresher = null;

			// Fade out our loading animation
			var f = $('loading2').effect('opacity', {
				duration: 750,
				frames: 10,
				transition: Fx.Transitions.quadOut,
				onComplete: function(){
				$('loading2').style.zIndex = '-1';
				}
			});
			f.start(1,0);

			$('target').style.cursor = 'move';
		}
	},

	/* Allow us to navigate within the image via the keyboard arrow buttons
	*/
	key: function(e){
		var d = 100;
		switch( e.keyCode ){
		case 37: // left
			this.scrollTo(-d,0);
			break;
		case 38: // up
			this.scrollTo(0,-d);
			break;
		case 39: // right
			this.scrollTo(d,0);
			break;
		case 40: // down
			this.scrollTo(0,d);
			break;
		case 107: // plus
			if(!e.ctrlKey) this.zoomIn();
			break;
		case 109: // minus
			if(!e.ctrlKey) this.zoomOut();
			break;
		}
	},

	/* Scroll resulting from a drag of the navigation window
	*/
	scrollNavigation: function( e ) {

		var xmove = 0;
		var ymove = 0;

		var zone_size = $("zone").getSize();
		var zone_w = zone_size.size.x;
		var zone_h = zone_size.size.y;

		if( e.event ){
			// From a mouse click
			var pos = $("navwin").getPosition();
			xmove = e.event.clientX - pos.x - zone_w/2;
			ymove = e.event.clientY - pos.y - zone_h/2;
		}
		else{
			// From a drag
			xmove = e.offsetLeft;
			ymove = e.offsetTop;
			if( (Math.abs(xmove-this.navpos[0]) < 3) && (Math.abs(ymove-this.navpos[1]) < 3) ) return;
		}

		if( xmove > (this.min_x - zone_w) ) xmove = this.min_x - zone_w;
		if( ymove > (this.min_y - zone_h) ) ymove = this.min_y - zone_h;
		if( xmove < 0 ) xmove = 0;
		if( ymove < 0 ) ymove = 0;

		this.rgn_x = xmove * this.wid / this.min_x;
		this.rgn_y = ymove * this.hei / this.min_y;

		this.requestImages();
			if( e.event ) this.positionZone();
	},

	/* Scroll from a target drag event
	*/
	scroll: function() {
		var xmove =  - $('target').offsetLeft;
		var ymove =  - $('target').offsetTop;
		this.scrollTo( xmove, ymove );
	},

	/* Scroll to a particular position
	*/
	scrollTo: function( x, y ) {

		if( x || y ){

			// To avoid unnecessary redrawing ...
			if( (Math.abs(x) < 3) && (Math.abs(y) < 3) ) return;

			this.rgn_x += x;
			this.rgn_y += y;

			if( this.rgn_x > this.wid - this.rgn_w ) this.rgn_x = this.wid - this.rgn_w;
			if( this.rgn_y > this.hei - this.rgn_h ) this.rgn_y = this.hei - this.rgn_h;
			if( this.rgn_x < 0 ) this.rgn_x = 0;
			if( this.rgn_y < 0 ) this.rgn_y = 0;

			this.requestImages();
			this.positionZone();

		}
	},

	/* Generic zoom function
	*/
	zoom: function( e ) {

		var event = new Event(e);

		// For mouse scrolls
		if( event.wheel ){
			if( event.wheel > 0 ) this.zoomIn();
			else if( event.wheel < 0 ) this.zoomOut();
		}

		// For double clicks
		else if(event.shift) {
			this.zoomOut();
		}
		else this.zoomIn();

	},

	/* Zoom in by a factor of 2
	*/
	zoomIn: function (){

		if( (this.wid <= (this.max_width/2)) && (this.hei <= (this.max_height/2)) ){

			this.wid = this.wid * 2;
			this.hei = this.hei * 2;

			if( this.xfit == 1 ){
		this.rgn_x = this.wid/2 - (this.rgn_w/2);
			}
			else if( this.wid > this.rgn_w ) this.rgn_x = 2*this.rgn_x + this.rgn_w/2;

			if( this.rgn_x > this.wid ) this.rgn_x = this.wid - this.rgn_w;
			if( this.rgn_x < 0 ) this.rgn_x = 0;

			if( this.yfit == 1 ){
		this.rgn_y = this.hei/2 - (this.rgn_h/2);
			}
			else if( this.hei > this.rgn_h ) this.rgn_y = this.rgn_y*2 + this.rgn_h/2;

			if( this.rgn_y > this.hei ) this.rgn_y = this.hei - this.rgn_h;
			if( this.rgn_y < 0 ) this.rgn_y = 0;

			this.resolution++;
			this.requestImages();
			this.positionZone();

		}
	},

	/* Zoom out by a factor of 2
	*/
	zoomOut: function(){

		if( (this.wid > this.rgn_w) || (this.hei > this.rgn_h) ){
			this.wid = this.wid / 2;
			this.hei = this.hei / 2;
		if(!this.rawJPEG){
			this.rgn_x = this.rgn_x/2 - (this.rgn_w/4);
			if( this.rgn_x + this.rgn_w > this.wid ) this.rgn_x = this.wid - this.rgn_w;
			if( this.rgn_x < 0 ){
			this.xfit=1;
			this.rgn_x = 0;
			}
			else this.xfit = 0;

			this.rgn_y = this.rgn_y/2 - (this.rgn_h/4);
			if( this.rgn_y + this.rgn_h > this.hei ) this.rgn_y = this.hei - this.rgn_h;
			if( this.rgn_y < 0 ){
			this.yfit=1;
			this.rgn_y = 0;
			}
			else this.yfit = 0;
		}

			this.resolution--;
			// Only request the images if we really want to load them, we may just be calculating resolutions
			if (this.init)
			this.requestImages();
			this.positionZone();
		}
	},

	/* Calculate some dimensions
	*/
	calculateMinSizes: function(){

		var tx = this.max_width;
		var ty = this.max_height;
		var thumb = 100;

		var r = this.resolution;
		while( tx > thumb ){
			tx = parseInt(tx / 2);
			ty = parseInt(ty / 2);
			// Make sure we don't set our navigation image too small!
			if( --r == 0 && (tx / 2 < 100)) break;
			if ((ty / 2) < 100) break;
		}

		this.min_x = tx;
		this.min_y = ty ;

		// Determine the resolution for this image view
		tx = this.max_width;
		ty = this.max_height;
		this.wid = tx;
		this.hei = ty;

	},

	/* Create our main and navigation windows
	*/
	createWindows: function(){

		// Get our window size - subtract some pixels to make sure the browser never
		// adds scrollbars
		var winWidth = Window.getWidth() - 5;
		var winHeight = Window.getHeight() - 5;

		// Calculate some sizes and create the navigation window
		this.calculateMinSizes();
		this.createNavigationWindow();

		// Create our main window target div, add our events and inject inside the frame
		var el = new Element('div', {'id': 'target'} );
		new TargetDrag( el, {onComplete: this.scroll.bindAsEventListener(this)} );
		el.injectInside( this.source );
		el.addEvent('mousewheel', this.zoom.bindAsEventListener(this) );
		el.addEvent('dblclick', this.zoom.bindAsEventListener(this) );
		
		$(this.source).style.width = winWidth+4 + "px";
		$(this.source).style.height = winHeight-17 + "px";
		this.rgn_w = winWidth+4;
		this.rgn_h = winHeight-17;

		if(!this.rawJPEG){
			this.reCenter();
			while( (this.wid > this.rgn_w) || (this.hei > this.rgn_h) ) {
				this.zoomOut();
			}
			//add this to take the resolution back out since the raw JPEG might be bigger than the "detail" image.  No good if that happens.
			var targetRes = Math.round(this.max_zoom / 2);
			while(this.resolution<targetRes){
				this.zoomIn();
			}
			this.middleRes = targetRes;
		}
		

		this.init = true;

		this.requestImages();
		this.positionZone();

		window.addEvent( 'resize', function(){ window.location=window.location; } );
		document.addEvent( 'keydown', this.key.bindAsEventListener(this) );
		

	},

	/* Create our navigation window
	*/
	createNavigationWindow: function() {

		// Create our navigation div and inject it inside our frame
		var navwin = new Element( 'div', {
			id: 'navwin',
			styles: {
				width: this.min_x + 'px',
				height: this.min_y + 'px'
			}
		});
		navwin.injectInside( this.source );

		// Create our navigation image and inject inside the div we just created
		var navimage = new Element( 'img', {
			id: 'navigation' ,
			styles: {
				width: this.min_x + 'px',
				height: this.min_y + 'px'
			}
		} );
		navimage.injectInside( navwin );

		// Create our navigation zone and inject inside the navigation div

		var zone = new Element( 'div', {
			id: 'zone',
			styles: {
				width: this.min_x/2 + 'px',
				height: this.min_y/2 + 'px',
				opacity: 0.4
			}
		});
		zone.injectInside( navwin );

		$("zone").makeDraggable({
			container: 'navwin',
				// Take a note of the starting coords of our drag zone
			onStart: function(){
				this.navpos = [$('zone').offsetLeft, $('zone').offsetTop];
			}.bind(this),
			onComplete: this.scrollNavigation.bindAsEventListener(this)
		});

		var cnt=1.0;
		var l = 1;
		// djatoka thumbnail conditions
		if (this.max_zoom <= 4) l = 0;
		if (this.max_zoom >= 6 && this.min_x > this.min_y) l = 1;
		if (l == 0 && this.min_y > this.min_x) l = 1;
		$("navigation").src = this.server + "?url_ver=Z39.88-2004&rft_id=" + this.fif + "&svc_id=" + this.svc_id + "&svc_val_fmt=" + this.svc_val_fmt + "&svc.rotate=0&svc.format=image/jpeg&svc.level=" + l;

		// Add our events
		$("navigation").addEvent('click', this.scrollNavigation.bindWithEvent(this) );
		$('navigation').addEvent('mousewheel', this.zoom.bindAsEventListener(this) );
		$('zone').addEvent('mousewheel', this.zoom.bindAsEventListener(this) );
		$("zone").addEvent( 'dblclick', this.zoom.bindWithEvent(this) );

	},

	/* Use a AJAX request to get the image size, tile size and number of resolutions from the server
	*/
	load: function(){

		new Ajax(this.server + "?url_ver=Z39.88-2004&rft_id=" + this.fif + "&svc_id=info:lanl-repo/svc/getMetadata",
		{
			method: 'get',
			onComplete: function(transport){
				$('loading3').style.display='none';
		
				var response = transport || "No response from server " + this.server;
				var p = eval("(" + response + ")");
				var tmp = p.levels;
				this.max_width = parseInt( p.width );
				this.max_height = parseInt( p.height );
				this.tileSize[0] = 256;
				this.tileSize[1] = 256;
				this.max_zoom = parseInt( p.levels );
				this.resolution = parseInt( p.levels );
				this.createWindows();
			}.bind(this),
			//onFailure: function(){ alert("No response from server"); }
			onFailure: function(){ }
		} ).request();

	},

	/* Recenter the image view
	*/
	reCenter: function(){
		//added by chris moyers.  honestly, not sure why this is being called for image's initial load...all I know is that it does weird things to plain old JPEG images.
		if(!this.rawJPEG){
			this.rgn_x = (this.wid-this.rgn_w)/2;
			this.rgn_y = (this.hei-this.rgn_h)/2;
		}
	},

	/* Create the OpenURL for the current viewport
	*/
	setOpenURL: function() {
		var w = parseInt(this.rgn_w);
		if( this.wid < this.rgn_w ) w = parseInt(this.wid);
		var h = parseInt(this.rgn_h);
		if( this.hei < this.rgn_h ) h = parseInt(this.hei);
		this.openUrl = this.server + "?url_ver=Z39.88-2004&rft_id=" + this.fif + "&svc_id=" + this.svc_id + "&svc_val_fmt=" + this.svc_val_fmt + "&svc.format=image/jpeg&svc.level=" + this.resolution + "&svc.rotate=0&svc.region=" + top_left_y + "," + top_left_x + "," + h + "," + w;
		$('logo').href = this.openUrl;
		var tempopenUrl = this.server + "?url_ver=Z39.88-2004&rft_id=" + this.fif + "&svc_id=" + this.svc_id + "&svc_val_fmt=" + this.svc_val_fmt + "&svc.format=image/jpeg&svc.level=" + this.middleRes + "&svc.rotate=0&svc.region=" + 0 + "," + 0 + "," + this.max_height + "," + this.max_width;
		if(imageURL===''){
			document.getElementById('saveImageButton').href+=escape(tempopenUrl);
			document.getElementById('printImageButton').href+=escape(tempopenUrl);
		}
	
	},

	/* Reposition the navigation rectangle on the overview image
	*/
	positionZone: function(){

		var pleft = (this.rgn_x/this.wid) * (this.min_x);
		if( pleft > this.min_x ) pleft = this.min_x;
		if( pleft < 0 ) pleft = 0;

		var ptop = (this.rgn_y/this.hei) * (this.min_y);
		if( ptop > this.min_y ) ptop = this.min_y;
		if( ptop < 0 ) ptop = 0;

		var width = (this.rgn_w/this.wid) * (this.min_x);
		if( pleft+width > this.min_x ) width = this.min_x - pleft;

		var height = (this.rgn_h/this.hei) * (this.min_y);
		if( height+ptop > this.min_y ) height = this.min_y - ptop;

		if( width < this.min_x ) this.xfit = 0;
		else this.xfit = 1;
		if( height < this.min_y ) this.yfit = 0;
		else this.yfit = 1;

		var border = $("zone").offsetHeight - $("zone").clientHeight;

		// Create a smooth special effect to move the zone to the new size and position
		var myEffects = new Fx.Styles('zone', {duration: 250, transition: Fx.Transitions.quadInOut});
		myEffects.start({
			'left': pleft - border/2,
			'top': ptop - border/2,
			'width': width,
			'height': height
		});

	}
	
	

});
