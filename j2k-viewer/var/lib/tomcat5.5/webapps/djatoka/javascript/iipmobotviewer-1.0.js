var IIP = new Class({
	Implements: [Events, Options],
	options: {
		frameID: 'frame',
		sourceImageURL: '',
		serverPath: '',
		rotation: 0,
		zoom: 2,
		navXPosition: 30,
		navYPosition: 30,
		navImageScale: 150,
		lazyLoadTiles: true,
		zoomToFit: true,
		navImageLevel: 1,
		navImageAutoSize: false,
		tileWidth: 256,
		tileHeight: 256,
		images: {
			blank: 'images/blank.gif',
			loading: 'images/spinner3-black.gif',
			modalClose: 'images/closelabel.gif'
		},
		helpFilePath: "help.html",
		svc_val_fmt: "info:ofi/fmt:kev:mtx:jpeg2000",
		svc_id: "info:lanl-repo/svc/getRegion",
		onInit: $empty,
		onInitComplete: $empty,
		onTileLoaded: $empty,
		onTileLoadError: $empty,
		onLoadTilesComplete: $empty,
		onScrollComplete: $empty,
		onDragComplete: $empty,
		onZoneDragComplete: $empty,
		onRefresh: $empty
	},
	initialize: function(options) {
		this.setOptions(options);
		this.fireEvent('onInit');
		this.frame = $(this.options.frameID);
		this.tileTarget = null;
		this.navigation = null;
		this.toolBar = null;
		this.navWindow = null;
		this.navZone = null;
		this.progressBar = null;
		this.navButtons = null;
		this.loadingImg=this.buildLoadingImage();
		this.rotation = this.options.rotation;
		this.zoom = this.options.zoom;
		this.navXPosition = this.options.navXPosition;
		this.navYPosition = this.options.navYPosition;
		this.windowWidth = 0,
		this.windowHeight = 0,
		this.tileCount = 0;
		this.tilesLoaded = 0;
		this.sourceImageObj = null;
		this.zoomLevelObjs = [];
		this.imageMap = null;
		this.bindWindowEvents();
		this.fireEvent('onInitComplete');
	},
	load: function(){ this.frame.adopt(this.loadingImg); this.fetchSourceImageObj(); },
	fetchSourceImageObj: function() {
		var qString = '?url_ver=Z39.88-2004&rft_id=' + this.options.sourceImageURL + '&svc_id=info:lanl-repo/svc/getMetadata';
		var currentRequest = new Request.JSON( {
			url: this.options.serverPath + qString,
			onComplete: function(responseObj) {
				this.sourceImageObj = responseObj;		
				if(this.sourceImageObj)	this.initializeUI();				
			}.bind(this),
			//onFailure: function() {  alert('Unable to get image and tile sizes from server!'); }
			onFailure: function() { }
		}).get();
	},
	initializeUI: function(){
		this.setInitialZoom();
		this.initializeTiles();
		this.initializeNavigation();
		this.positionNavigationZone();
	},
	initializeTiles: function(){
		this.tileTarget = this.buildTileTarget();
		this.frame.adopt(this.tileTarget);
		this.buildImageMap();
		this.rotateImageMap();
		this.sortImageMap();
		this.calculateTilePositions();
		this.loadTiles();
		this.lazyLoadImages();
		this.bindTileTargetEvents();
	},
	initializeNavigation: function(){
		this.navigation = this.buildNavigation();
		this.frame.adopt(this.navigation);
		this.bindNavigationEvents();
		this.setProgress();
	},
	setProgress: function(){
		var loadBarTimer = setInterval(function(){
			if(this.tileCount==this.tilesLoaded){
				this.refreshLoadBar();
				$clear(loadBarTimer);
				loadBarTimer=null;
			}else{ this.refreshLoadBar(); }
		}.bind(this), 100);
	},
	setInitialZoom: function(){
		if(this.options.zoomToFit){
			for(var level=this.sourceImageObj.levels; level>=0; level--){
				var zoomSize = this.getZoomSize(level);
				if(zoomSize.width<this.frame.offsetWidth && zoomSize.height<this.frame.offsetHeight){
					if(level+1 < this.sourceImageObj.levels) this.zoom = level+1;
					else this.zoom = level;
					break;
				}
				if(level==1) this.zoom=1;
			}
		}
	},
	buildTileTarget: function(){
		var tileTarget = new Element('div', {
			'id': 'tileTarget',
			morph: { 
				duration: 'short',
				transition: Fx.Transitions.Quad.easeInOut,
				onComplete: function(){ this.fireEvent('onScrollComplete');  }.bind(this)
			}
		});
		return tileTarget;
	},
	buildNavigation: function(){
		var navSize = this.getNavSize();
		var navigation = new Element('div', {
			id: 'navigation',
			styles: { 'width': navSize.width, 'height': navSize.height, 'top': this.navYPosition, 'right': this.navXPosition }
		});
		this.toolBar = this.buildToolbar();
		this.navWindow = this.buildNavigationWindow();
		this.progressBar = this.buildProgressBar();
		this.navButtons = this.buildNavigationButtons();
		navigation.adopt(this.toolBar, this.navWindow, this.navButtons, this.progressBar);
		return navigation;
	},
	buildToolbar: function(){
		var toolBar = new Element('div', {
			id: 'toolbar',
			styles: { 'overflow':'hidden' },
			events: { dblclick: function(){ this.navButtons.slide('toggle'); }.bind(this) }
		});
		toolBar.store( 'tip:text', '* Drag to move<br/>* Double Click to show/hide navigation buttons' );
		return toolBar;
	},
	buildNavigationWindow: function(){
		var navSize = this.getNavSize();
		var navWindow = new Element('div', {
			id: 'navigationwindow',
			styles: { 'width': navSize.width, 'height': navSize.height }
		});
		this.navImage = this.buildNavigationImage();
		this.navZone = this.buildNavigationZone();
		navWindow.adopt(this.navImage, this.navZone);
		return navWindow;
	},
	buildNavigationImage: function(){
		var level = this.getNavImageLevel();
		var navImageLevelSrc = this.options.serverPath + "?url_ver=Z39.88-2004" +"&rft_id="	+ this.options.sourceImageURL + "&svc_id=" + this.options.svc_id + "&svc_val_fmt=" + this.options.svc_val_fmt + "&svc.format=image/jpeg" +"&svc.level=" + level + "&svc.rotate=" + this.rotation; 
		var navImageScaleSrc = this.options.serverPath + "?url_ver=Z39.88-2004" +"&rft_id="	+ this.options.sourceImageURL + "&svc_id=" + this.options.svc_id + "&svc_val_fmt=" + this.options.svc_val_fmt + "&svc.format=image/jpeg" +"&svc.scale=" + this.options.navImageScale + "&svc.rotate=" + this.rotation; 		
		var source = (this.options.navImageAutoSize) ? navImageLevelSrc : navImageScaleSrc;
		var navImage = new Element('img', { id: 'navigationImage', src: source });
		return navImage;
	},
	buildNavigationZone: function(){
		var navZone = new Element('div', {
			id: 'zone',
			styles: { position: 'absolute', width: '50%', height: '50%', 'opacity': 0.4 },
			morph: { duration: 'short', transition: Fx.Transitions.Quad.easeInOut }
		});
		return navZone;
	},
	buildProgressBar: function(){
		var progressBar = new Element('div', {
			id: 'progressBar',
			html: '<div id="loadBar"></div>',
			styles: { width: '100%' },
			tween: { duration: 'short', transition: Fx.Transitions.Quad.easeInOut, link: 'cancel' }
		});
		return progressBar;
	},
	buildNavigationButtons: function(){
		var navButtons = new Element('div', {
			id: 'navbuttons',
			html: '<img id="shiftLeft" src="images/left.png" alt="Pan Left" title="Pan Left" />'+
				'<img id="shiftUp" src="images/up.png" alt="Pan Up" title="Pan Up" />'+
				'<img id="shiftRight" src="images/right.png" alt="Pan Right" title="Pan Right" />'+
				'<br/>'+
				'<img id="shiftDown" src="images/down.png" alt="Pan Down" title="Pan Down" />'+
				'<br/>'+
				'<img id="zoomIn" src="images/zoomIn.png" alt="Zoom In" title="Zoom In" />'+
				'<img id="zoomOut" src="images/zoomOut.png" alt="Zoom Out" title="Zoom Out" />'+
				'<img id="reset" src="images/reset.png" alt="Refresh" title="Refresh" />'+
				'<img id="rotateLeft" src="images/rotate_left.png" alt="Rotate Left" title="Rotate Left" />'+
				'<img id="rotateRight" src="images/rotate_right.png" alt="Rotate Right" title="Rotate Right" />'+
				'<img id="Download" src="images/download.png" alt="Download & Save" title="Download & Save" />'+
				'<img id="Help" src="images/help.png" alt="Help" title="Help" />',
			styles: {
				'opacity': 0.6
			}
		});
		navButtons.set('slide', {duration: 'short', transition: Fx.Transitions.Quad.easeInOut, mode:'vertical'});
		return navButtons;
	},
	buildLoadingImage: function(){
		var loadingImg = new Element('img', {
			'class': 'loadingImg',
			src: this.options.images.loading,
			styles: { position: 'absolute',  top: '200px', left: '48%', 'z-index': '1000' },
			tween: { duration: 'short', transition: Fx.Transitions.Quad.easeInOut, link: 'cancel' }
		});
		return loadingImg;
	},
	buildTile: function(tileObj){
		var tile = new Element('img', {
			'source': tileObj.src,
			'class': 'imageTile',
			'styles': {'top':tileObj.top, 'left':tileObj.left, 'width':tileObj.width, 'height':tileObj.height, 'background-image':'none'},
			'events': {
				'load': function(){ this.fireEvent('onTileLoaded'); }.bind(this),
				'error': function(){  
					this.set('src', this.get('source'));
					this.fireEvent('onTileLoadError');
				},
				'loadImage': function(){
					if(this.getStyle('background-image')=='none') this.setStyle('background-image', 'url('+this.get('source')+')');
				}
			}
		});
		tile.set('src', this.options.images.blank);
		if(!this.options.lazyLoadTiles) tile.fireEvent('loadImage');
		return tile;
	},
	buildTileObj: function(imageWidth, imageHeight, rowCount, colCount, rowIndex, colIndex){	
		var tileObj = {top:0, left:0, sourceX:0, sourceY:0, xIndex:colIndex, yIndex:rowIndex, width:0, height:0, src:''};
		var scale = this.getSizeScale(this.zoom);
		var scaledTileWidth = this.options.tileWidth * scale;
		var scaledTileHeight = this.options.tileHeight * scale;
		tileObj.sourceX = (colIndex*scaledTileWidth);
		tileObj.sourceY = (rowIndex*scaledTileHeight);
		var lastRowTile = (rowIndex==rowCount-1) ? true : false;
		var lastColTile = (colIndex==colCount-1) ? true : false;
		var widthFragment=null;
		var heightFragment=null;
		if(lastColTile)	widthFragment = imageWidth - (colIndex*this.options.tileWidth);
		if(lastRowTile)	heightFragment = imageHeight - (rowIndex*this.options.tileHeight);
		tileObj.width = widthFragment || this.options.tileWidth;
		tileObj.height = heightFragment || this.options.tileHeight;		
		var src = this.options.serverPath + "?url_ver=Z39.88-2004&rft_id=" + this.options.sourceImageURL + "&svc_id=" + this.options.svc_id + "&svc_val_fmt=" + this.options.svc_val_fmt + "&svc.format=image/jpeg" + "&svc.level=" + this.zoom + "&svc.rotate="+this.rotation + "&svc.region=" + tileObj.sourceY + "," + tileObj.sourceX + ","+ tileObj.height +","+ tileObj.width; 
		tileObj.src = src;
		return tileObj;
	},
	buildImageMap: function(){
		var imageMap = [];
		var scale = this.getSizeScale(this.zoom);
		var imageWidth = Math.round(this.sourceImageObj.width/scale);
		var imageHeight = Math.round(this.sourceImageObj.height/scale);
		var rowCount = Math.ceil(imageHeight/this.options.tileHeight);
		var colCount = Math.ceil(imageWidth/this.options.tileWidth);
		this.tilesLoaded=0;
		this.tileCount = (rowCount*colCount);
		var rowIndex;
		for(rowIndex=0;rowIndex<rowCount;rowIndex++){
			var row = [];
			var colIndex;
			for(colIndex=0;colIndex<colCount;colIndex++){
				var tileObj = this.buildTileObj(imageWidth, imageHeight, rowCount, colCount, rowIndex, colIndex);
				row.push(tileObj);
			}
			imageMap.push(row);
		}
		this.imageMap = imageMap;
	},
	rotateImageMap: function(){
		if( this.rotation==90 || this.rotation==270 ){
			this.imageMap.each(function(row){
				row.each(function(tileObj){
					var width = tileObj.width;
					var height = tileObj.height;
					tileObj.width = height;
					tileObj.height = width;
				}.bind(this))
			}.bind(this));
		}
	},
	sortImageMap: function(){
		switch(this.rotation){
			case 90: this.swapRowWithCol(); this.invertXOrder(); break;
			case 180: this.invertXOrder(); this.invertYOrder(); break;
			case 270: this.swapRowWithCol(); this.invertYOrder(); break;
		}
	},
	swapRowWithCol: function(){
		var swapped = [];
		var rowCount = this.imageMap.length;
		var colCount = this.imageMap[0].length;
		for(var i=0;i<rowCount;i++){
			for(var j=0;j<colCount;j++){
				var tileObj = this.imageMap[i][j];
				if(!swapped[j]){
					var newRow = new Array();
					swapped[j] = newRow;
				}
				swapped[j][i] = tileObj;
			}			
		}
		this.imageMap = swapped;
	},
	invertXOrder: function(){
		var sorted = new Array();
		this.imageMap.each(function(row, i){
			var sortedRow = row.reverse();
			sorted.push(sortedRow);
		}.bind(this));
		this.imageMap = sorted;
	},
	invertYOrder: function(){
		this.imageMap = this.imageMap.reverse();
	},
	calculateTilePositions: function(){
		var xOffset = 0;
		var yOffset = 0;
		this.imageMap.each(function(row){
			xOffset = 0;
			var curYOffset = 0;
			row.each(function(tileObj){
				tileObj.left = xOffset;
				tileObj.top = yOffset;
				xOffset+=tileObj.width;
				curYOffset=tileObj.height;
			}.bind(this))
			yOffset+=curYOffset;
		}.bind(this));
		this.setTileTargetSize(xOffset, yOffset);
	},
	setTileTargetSize: function(width, height){ this.tileTarget.setStyles({'width': width, 'height': height}); },
	loadTiles: function(){
		this.imageMap.each(function(tileRow){
			tileRow.each(function(tileObj){
				var tile = this.buildTile(tileObj);
				tile.inject(this.tileTarget);
			}.bind(this));
		}.bind(this));
		this.fireEvent('onLoadTilesComplete');
	},
	refreshTiles: function(){ this.tileTarget.destroy(); this.initializeTiles(); },
	setFrameSize: function(){ this.frame.setStyles({ width: window.getWidth(), height: window.getHeight() }) },
	lazyLoadImages: function(){
		if(this.options.lazyLoadTiles){
			this.tileTarget.getChildren().each(function(tile){
				if( this.isVisible(tile) ){ tile.fireEvent('loadImage'); }
			}.bind(this));
		}
	},		
	isVisible: function(tile){
		var offset = this.getTileTargetOffsets();
		var leftBound = Math.abs(offset.left);
		var rightBound = Math.abs(this.tileTarget.offsetWidth-offset.right);
		var topBound = Math.abs(offset.top);
		var bottomBound = Math.abs(this.tileTarget.offsetHeight-offset.bottom);
		return (
			//top left corner
			((tile.offsetTop>=topBound && tile.offsetTop<=bottomBound) 
			&& (tile.offsetLeft>=leftBound && tile.offsetLeft<=rightBound))
			||
			//bottom right corner
			((tile.offsetTop+tile.offsetHeight>=topBound && tile.offsetTop+tile.offsetHeight<=bottomBound) 
			&& (tile.offsetLeft+tile.offsetWidth>=leftBound && tile.offsetLeft+tile.offsetWidth<=rightBound))
			||
			//top right corner
			((tile.offsetTop>=topBound && tile.offsetTop<=bottomBound) 
			&& (tile.offsetLeft+tile.offsetWidth>=leftBound && tile.offsetLeft+tile.offsetWidth<=rightBound))
			||
			//bottom left corner
			((tile.offsetTop+tile.offsetHeight>=topBound && tile.offsetTop+tile.offsetHeight<=bottomBound) 
			&& (tile.offsetLeft>=leftBound && tile.offsetLeft<=rightBound))
		) ? true : false;
	},
	refreshNavigation: function(){ this.navigation.destroy(); this.initializeNavigation(); this.positionNavigationZone(); },
	scrollTo: function(x, y){ this.tileTarget.morph({ left: x, top: y }); },
	positionNavigationZone: function(){
 		var scale = this.getTileTargetSizeScale();
		var navScale = this.getNavigationSizeScale();
		this.navZone.morph({
			width: this.navWindow.offsetWidth * scale.width, 
			height: this.navWindow.offsetHeight * scale.height,
			top: Math.abs(this.tileTarget.offsetTop) * navScale.y,
			left: Math.abs(this.tileTarget.offsetLeft) * navScale.x
		});
	},
	getNavigationSizeScale: function(){
		var scale = {
			x: this.navWindow.offsetWidth/this.tileTarget.offsetWidth,
			y: this.navWindow.offsetHeight/this.tileTarget.offsetHeight
		};
		if(scale.x>1) scale.x = 1;
		if(scale.y>1) scale.y = 1;
		return scale;
	},	
	getNavImageLevel: function(){
		var level = this.options.navImageLevel;
		var navImgLarge = true;
		for(var i=this.sourceImageObj.levels; i>=0; i--){
			var navSize = this.getZoomSize(i);
			if(navSize.width<=this.frame.offsetWidth/2 && navSize.height<=this.frame.offsetHeight/2){
				level = i;
				navImgLarge = false;
				break;
			}
		}
		if(navImgLarge) level = 0;
		return level;
	},
	getScaledNavImageSize: function(){
		var imgObj = this.sourceImageObj;
		var longEdge = (Math.abs(imgObj.width) >= Math.abs(imgObj.height)) ? imgObj.width : imgObj.height;
		var scaleFactor = (this.options.navImageScale/longEdge);
		var retObj = {
			width: (this.rotation==0||this.rotation==180) ? Math.abs(imgObj.width*scaleFactor) : Math.abs(imgObj.height*scaleFactor), 
			height: (this.rotation==0||this.rotation==180) ? Math.abs(imgObj.height*scaleFactor) : Math.abs(imgObj.width*scaleFactor)
		}
		return retObj;
	},
	getNavSize: function(){
		var navSize = null;
		if(this.options.navImageAutoSize){
			var level = this.getNavImageLevel();
			navSize = this.getZoomSize(level);
		}else{
			navSize = this.getScaledNavImageSize();
		}
		return navSize
	},
	getTileTargetSizeScale: function(){
		var scale = {
			width: this.frame.offsetWidth/this.tileTarget.offsetWidth,
			height: this.frame.offsetHeight/this.tileTarget.offsetHeight
		};
		if(scale.width>1) scale.width = 1;
		if(scale.height>1) scale.height = 1;
		return scale;
	},
	getZoomSize: function(level){
		var scale = this.getSizeScale(level);
		var size = {
			width: (this.rotation==0||this.rotation==180) ? this.sourceImageObj.width/scale : this.sourceImageObj.height/scale,
			height: (this.rotation==0||this.rotation==180) ? this.sourceImageObj.height/scale : this.sourceImageObj.width/scale
		};
		return size;
	},
	getSizeScale: function(level){ return Math.pow(2, (this.sourceImageObj.levels-level) ); },
	getTileTargetOffsets: function(){
		return {
			top: this.tileTarget.offsetTop,
			left: this.tileTarget.offsetLeft,
			bottom: this.tileTarget.offsetHeight - (Math.abs(this.tileTarget.offsetTop)+this.frame.offsetHeight),
			right: this.tileTarget.offsetWidth - (Math.abs(this.tileTarget.offsetLeft)+this.frame.offsetWidth)
		}
	},
	refreshLoadBar: function() {
		var width = (this.tilesLoaded / this.tileCount) * this.navigation.getWidth();
		var loadBar = this.progressBar.getFirst();
		loadBar.set({
			'html': 'loading&nbsp;:&nbsp;'+Math.round(this.tilesLoaded/this.tileCount*100) + '%',
			'styles': { 'width': width }
		});
		if( this.progressBar.getStyle('opacity') != 0.85 ) this.progressBar.setStyle( 'opacity', 0.85 );
		if( this.tilesLoaded == this.tileCount ) this.progressBar.fade('out'); 
	},
	/*////////
	////EVENT BINDINGS
	////////*/
	bindWindowEvents: function(){
		document.ondragstart = function () { return false; }; //IE drag hack
		this.addEvent('onTileLoaded', function(){ this.tilesLoaded++; }.bind(this));
		this.addEvent('onLoadTilesComplete', function(){ this.loadingImg.setStyle('display', 'none'); }.bind(this));
		window.addEvents({ 'domready': this.load.bindWithEvent(this), 'resize': this.windowResize.bindWithEvent(this) });
		document.addEvents({ 'keydown': this.windowKeyPress.bindWithEvent(this) });
		this.addEvent('onScrollComplete', function(){ this.lazyLoadImages(); }.bind(this));
		this.addEvent('onDragComplete', function(){ this.lazyLoadImages(); }.bind(this));
	},
	bindTileTargetEvents: function(){
		var leftLimit = (this.tileTarget.getWidth() > this.frame.offsetWidth) ? 0 - (this.tileTarget.offsetWidth - this.frame.offsetWidth) : 0;
		var rightLimit = 0;
		var topLimit = (this.tileTarget.getHeight() > this.frame.offsetHeight) ? 0 - (this.tileTarget.offsetHeight - this.frame.offsetHeight) : 0;
		var bottomLimit = 0; 
		this.tileTarget.makeDraggable({
			limit: { x: [leftLimit, rightLimit], y: [topLimit, bottomLimit] },
			onComplete: function(){ this.fireEvent('onDragComplete'); }.bind(this)
		});
		this.tileTarget.addEvents({ 'dblclick': this.zoomEvent.bind(this), 'mousewheel': this.zoomEvent.bind(this) });
	},
	bindNavigationEvents: function(){
		this.addEvent('onScrollComplete', function(){ this.positionNavigationZone(); }.bind(this));
		this.addEvent('onDragComplete', function(){ this.positionNavigationZone(); }.bind(this));
		this.addEvent('onZoneDragComplete', function(){
			var scale = this.getNavigationSizeScale();
			this.scrollTo((this.navZone.offsetLeft * -1) / scale.x, (this.navZone.offsetTop * -1) / scale.y);
		}.bind(this));
		this.navigation.makeDraggable({
			container:this.frame, 
			handle:this.toolBar,
			onComplete: function(){ 
				this.navXPosition = this.frame.offsetWidth-(this.navigation.offsetLeft+this.navigation.offsetWidth); 
				this.navYPosition = this.navigation.offsetTop; 
			}.bind(this)
		});
		this.navWindow.addEvent( 'click', this.navWindowClick.bindWithEvent(this) );
		this.navWindow.addEvent( 'mousewheel', this.zoomEvent.bindWithEvent(this) );
		this.bindNavigationButtonEvents();
		this.bindZoneEvents();
	},
	bindNavigationButtonEvents: function(){
		$('zoomIn').addEvent( 'click', this.zoomInClick.bind(this) );
		$('zoomOut').addEvent( 'click', this.zoomOutClick.bind(this) );
		$('reset').addEvent( 'click', this.refreshClick.bind(this)  );
		$('shiftLeft').addEvent( 'click', this.scrollLeftClick.bind(this) );
		$('shiftUp').addEvent( 'click', this.scrollUpClick.bind(this) );
		$('shiftDown').addEvent( 'click', this.scrollDownClick.bind(this) );
		$('shiftRight').addEvent( 'click', this.scrollRightClick.bind(this) );
		$('rotateLeft').addEvent( 'click', this.rotateLeftClick.bind(this) );
		$('rotateRight').addEvent( 'click', this.rotateRightClick.bind(this) );
		$('Download').addEvent( 'click', this.downloadClick.bind(this) );
		$('Help').addEvent( 'click', this.helpClick.bind(this) );
	},
	bindZoneEvents: function(){
		this.navZone.makeDraggable({
			container: this.navWindow,
			onComplete: function(){ this.fireEvent('onZoneDragComplete'); }.bind(this)
		});
	    this.navZone.addEvents({ 
			'mousewheel': this.zoomEvent.bind(this),
			'dblclick': this.zoomEvent.bind(this),
			'click': function(e){ var e = new Event(e); e.stopPropagation(); }
		});
	},
	/*///////
	////EVENT HANDLERS
	///////*/
	windowKeyPress: function(e){ 
		e = new Event(e);
		switch( e.code ){
			case 37: /* left */ this.scrollLeftClick(); break;
			case 38: /* up */ this.scrollUpClick(); break;
			case 39: /* right */ this.scrollRightClick(); break;
			case 40: /* down */ this.scrollDownClick(); break;
			case 107: /* plus */ if(!e.control) this.zoomInClick(); break;
			case 109: /* minus */ if(!e.control) this.zoomOutClick(); break;
			default: return e.key; break;
		}
	},
	resizeTimeout: null,
	windowResize: function(e){ 
		if(e){
			var event = new Event(e).stop();
			if(this.resizeTimeout) clearTimeout(this.resizeTimeout);
			this.resizeTimeout = setTimeout(function(){ this.execWindowResize(); }.bind(this), 200);
		}
	},
	execWindowResize: function(){
		this.setFrameSize();
		this.setInitialZoom();
		this.refreshTiles();	
		this.refreshNavigation();
		this.resizeTimeout = null;
	},
	zoomInClick: function(){
		if(this.zoom < this.sourceImageObj.levels) this.zoomTo(this.zoom+1); 
	},
	zoomOutClick: function(){
		if(this.zoom > 0) this.zoomTo(this.zoom-1);
	},
	zoomTo: function(level){
		var oldSize = this.getZoomSize(this.zoom);
		var newSize = this.getZoomSize(level);
		this.zoom=level;
		var scale = newSize.width/oldSize.width;
		var leftOffset = (this.tileTarget.offsetLeft*scale);
		var topOffset = (this.tileTarget.offsetTop*scale);
		if(Math.abs(this.tileTarget.offsetLeft*scale)+this.frame.offsetWidth > this.tileTarget.offsetWidth*scale) leftOffset = ((this.tileTarget.offsetWidth*scale)-this.frame.offsetWidth)*-1;
		if(Math.abs(this.tileTarget.offsetTop*scale)+this.frame.offsetHeight > this.tileTarget.offsetHeight*scale) topOffset = ((this.tileTarget.offsetHeight*scale)-this.frame.offsetHeight)*-1;
		if(this.tileTarget.offsetWidth*scale < this.frame.offsetWidth) leftOffset = 0;
		if(this.tileTarget.offsetHeight*scale < this.frame.offsetHeight) topOffset = 0;		
		this.refreshTiles();
		this.setProgress();
		this.tileTarget.setStyles({top: topOffset, left: leftOffset});
		this.lazyLoadImages();
		this.positionNavigationZone();
	},
	zoomEvent: function(e) {
		var e = new Event(e).stop();
		if( e.wheel ){
			if( e.wheel > 0 ) this.zoomInClick();
			else if( e.wheel < 0 ) this.zoomOutClick();
		}
		else if( e.shift ){ this.zoomOutClick(); }
		else this.zoomInClick();
	},
	refreshClick: function(){
		this.refreshTiles();
		this.refreshNavigation();
	},
	scrollLeftClick: function(){
		var offset = this.getTileTargetOffsets();
		if(offset.left>=0) return;
		var scrollIncrement = (Math.abs(offset.left) > this.frame.offsetWidth/2) ? this.frame.offsetWidth/2 : Math.abs(offset.left);
		this.scrollTo(offset.left+scrollIncrement, offset.top);		
	},
	scrollRightClick: function(){
		var offset = this.getTileTargetOffsets();
		if(offset.right<=0) return;
		var scrollIncrement = (offset.right > this.frame.offsetWidth/2) ? this.frame.offsetWidth/2 : offset.right;
		this.scrollTo(offset.left-scrollIncrement, offset.top);
	},
	scrollUpClick: function(){
		var offset = this.getTileTargetOffsets();
		if(offset.top>=0) return;
		var scrollIncrement = (Math.abs(offset.top)>this.frame.offsetHeight/2) ? this.frame.offsetHeight/2 : Math.abs(offset.top);
		this.scrollTo(this.tileTarget.offsetLeft, offset.top+scrollIncrement);
	},
	scrollDownClick: function(){
		var offset = this.getTileTargetOffsets();
		if(offset.bottom<=0) return;
		var scrollIncrement = (offset.bottom > this.frame.offsetHeight/2) ? this.frame.offsetHeight/2 : (offset.bottom);
		this.scrollTo(offset.left, offset.top-scrollIncrement);
	},
	navWindowClick: function( e ) {
		var e = new Event(e);
		var offset = this.getTileTargetOffsets();
		var mouseX, mouseY = 0;
		if(Browser.Engine.trident){ mouseX=e.event.x; mouseY=e.event.y }
		else{ mouseX=e.event.layerX; mouseY=e.event.layerY; }
		var navXCenter = mouseX - (this.navZone.offsetWidth/2);
		var navYCenter = mouseY - (this.navZone.offsetHeight/2);
		var scale = this.getNavigationSizeScale();
		var tileTargetOffsetX = (Math.round(navXCenter/scale.x)*-1);
		var tileTargetOffsetY = (Math.round(navYCenter/scale.y)*-1);
		/* RIGHT */
		if(Math.abs(tileTargetOffsetX)+this.frame.offsetWidth>this.tileTarget.offsetWidth) tileTargetOffsetX = this.frame.offsetWidth-this.tileTarget.offsetWidth;
		/* LEFT */
		if(tileTargetOffsetX>0)	tileTargetOffsetX=0;
		/* TOP */
		if(tileTargetOffsetY>0) tileTargetOffsetY=0;
		/* BOTTOM */
		if(Math.abs(tileTargetOffsetY)+this.frame.offsetHeight>this.tileTarget.offsetHeight) tileTargetOffsetY=this.frame.offsetHeight-this.tileTarget.offsetHeight;
		this.scrollTo(tileTargetOffsetX, tileTargetOffsetY);
	},
	rotateLeftClick: function(){
		if(this.rotation==0) this.rotation = 270;
		else this.rotation -= 90;
		this.refreshTiles();
		this.refreshNavigation();
	},
	rotateRightClick: function(){
		if(this.rotation==270) this.rotation = 0;
		else this.rotation += 90;
		this.refreshTiles();
		this.refreshNavigation();
	},
	downloadClick: function(){
		this.downloadModal = this.buildDownloadModal();
		var downloadImgLinks = this.buildDownloadImgLinks();
		this.downloadModal.show('');
		downloadImgLinks.inject(this.downloadModal.title);
		var links = downloadImgLinks.getChildren();
		if(links.length>0){ links[0].fireEvent('click'); }
	},
	helpClick: function(){
		this.helpModal = this.buildHelpModal();
		this.helpModal.show('');
	},	
	buildHelpModal: function(){
		var HelpModal = new Modal({
			'width': this.frame.offsetWidth*0.75, 
			'height': this.frame.offsetHeight*0.75,
			'closeBtn': this.options.images.modalClose
		});
		HelpModal.container.setStyles({ background:'#fff', border:'1px solid #666', padding:'10px' });
		HelpModal.title.setStyle('border-bottom','1px solid #eee');
		HelpModal.message.setStyle('overflow','auto');
		HelpModal.message.set('load', {method: 'get'});
		HelpModal.message.load(this.options.helpFilePath + "?t=" + new Date().getTime());
		HelpModal.addEvent('onResize', function(){ this.onModalResize(HelpModal); }.bind(this) );	
		return HelpModal;
	},
	/*////////
	////MODAL DOWNLOAD WINDOW
	////////*/
	buildDownloadModal: function(){
		var DownloadModal = new Modal({ 'width': this.frame.offsetWidth*0.75, 'height': this.frame.offsetHeight*0.75, 'closeBtn': this.options.images.modalClose });
		DownloadModal.container.setStyles({ background:'#fff', border:'1px solid #666', padding:'10px' });
		DownloadModal.title.setStyle('border-bottom','1px solid #eee');
		DownloadModal.message.set('align','center');
		DownloadModal.message.setStyle('overflow','auto');
		DownloadModal.addEvent('onResize', function(){ this.onModalResize(DownloadModal); }.bind(this) );	
		return DownloadModal;
	},
	createDLImageURL: function(level) {
		if(level>this.sourceImageObj.levels) return;
		var DLUrl = this.options.serverPath + "?url_ver=Z39.88-2004" + "&rft_id=" + this.options.sourceImageURL + "&svc_id=" + this.options.svc_id + "&svc_val_fmt=" + this.options.svc_val_fmt + "&svc.format=image/jpeg&svc.level=" + level + "&svc.rotate=" + this.rotation + "&svc.region=" + 0 + "," + 0 + "," + 10000 + "," + 10000;
		return DLUrl;
	},
	createCroppedImageURL: function() {
		var scale = this.getSizeScale(this.zoom);
		var offset = this.getTileTargetOffsets();
		var width = Math.round(this.frame.offsetWidth);
		var height = Math.round(this.frame.offsetHeight);
		var scaledX = Math.abs(offset.left*scale);
		var scaledY = scaledY = Math.abs(offset.top*scale);
		switch(this.rotation){
			case 90:
				width = Math.round(this.frame.offsetHeight);
				height = Math.round(this.frame.offsetWidth);
				if(this.frame.offsetWidth<this.tileTarget.offsetWidth) scaledX = Math.abs(offset.top)*scale;
				else scaledX = 0;
				if(this.frame.offsetHeight<this.tileTarget.offsetHeight) scaledY = Math.abs(offset.right)*scale;
				else scaledY = 0;
			break;
			case 180:
				if(this.frame.offsetWidth<this.tileTarget.offsetWidth) scaledX = Math.abs(offset.right)*scale;
				else scaledX = 0;
				if(this.frame.offsetHeight<this.tileTarget.offsetHeight) scaledY = Math.abs(offset.bottom)*scale;
				else scaledY = 0;
			break;
			case 270:
				width = Math.round(this.frame.offsetHeight);
				height = Math.round(this.frame.offsetWidth);
				if(this.frame.offsetWidth<this.tileTarget.offsetWidth) scaledX = Math.abs(offset.bottom)*scale;
				else scaledX = 0;
				if(this.frame.offsetHeight<this.tileTarget.offsetHeight) scaledY = Math.abs(offset.left)*scale;
				else scaledY = 0;
			break;
		}
		var DLUrl = this.options.serverPath + "?url_ver=Z39.88-2004" + "&rft_id=" + this.options.sourceImageURL + "&svc_id=" + this.options.svc_id + "&svc_val_fmt=" + this.options.svc_val_fmt + "&svc.format=image/jpeg&svc.level=" + this.zoom + "&svc.rotate=" + this.rotation + "&svc.region=" + scaledY + "," + scaledX + "," + height + "," 	+ width;
		return DLUrl;
	},
	onModalResize: function(modal){
		var resizeX = new Fx.Morph(modal.container, {duration: 'short', transition: Fx.Transitions.Quad.easeInOut});
		resizeX.start({ 'width': (this.frame.offsetWidth * 0.75), 'height': (this.frame.offsetHeight * 0.75) });
		var resizeY = new Fx.Morph(modal.message, {duration: 'short', transition: Fx.Transitions.Quad.easeInOut});
		resizeY.start({ 'width': (this.frame.offsetWidth * 0.75), 'height': ((this.frame.offsetHeight * 0.65)) });
	},
	buildDownloadImgLinks: function(){
		var imgLinks = new Element('div',{ 'class': 'downloadImgLinks' });
		var cropImgLink = this.buildDownloadImgLink("cropped", this.createCroppedImageURL() );
		cropImgLink.inject(imgLinks);
		for(var level=1; level<=this.sourceImageObj.levels;level++){
			var curURL = this.createDLImageURL(level);
			var curLink = this.buildDownloadImgLink(level, curURL);
			curLink.inject(imgLinks);
		}
		return imgLinks;		
	},
	buildDownloadImgLink: function(size, url){
		var link = new Element('img', {
			'width': '34',
			'height': '43',
			'border': 0,
			'class': 'imgLink',
			'src': this.options.images.blank,
			'styles': { 'background-image': 'url(images/thumbBG.gif)', 'background-repeat': 'no-repeat', 'width': '34px', 'height': '43px' },
			'events': { 'click': function(){ this.loadDLImage(url); }.bind(this) }
		});
		if(size=='cropped'){ link.setStyle('background-position', '-170px 0px'); link.set('alt', 'Cropped image'); }
		else{ var bgOffset = 0-((link.width*size)-link.width); link.setStyle('background-position', bgOffset+'px 0px'); }
		return link;
	},
	loadDLImage: function(url){
		this.downloadModal.message.empty();
		var img = new Element('img', { src:url });
		img.inject(this.downloadModal.message);
	}
});

