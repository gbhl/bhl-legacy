var Modal = new Class({
	Implements: [Events, Options],
	options: {
		speed: 300,
		maskOpacity: 0.3,
		maskColor: '#000000',
		width: 400,
		height: 'auto',
		classPrefix: 'Modal',
		onHide: $empty,
		onShow: $empty,
		onStart: $empty,
		onResize: $empty,
		closeBtn: $empty
	},
 
	initialize: function(options) {
		this.setOptions(options);
		this.isShowing = false;
		this.mask = new Element('div', {
			'class':this.options.classPrefix+'Mask',
			'styles':{
				'position':'absolute',
				'top': 0,
				'left': 0,
				'opacity': 0,
				'height': window.getScrollSize().y,
				'width': window.getScrollSize().x,
				'z-index': 9999,
				'background-color':this.options.maskColor
			},
			'events':{
				'click':this.hide.bindWithEvent(this)
			}
		});
		this.pop = new Element('div', {
			'class':this.options.classPrefix+'Pop',
			'styles':{
				'position': 'absolute',
				'visibility': 'hidden',
				'width': '99%',
				'margin': 0,
				'z-index': 10000
			}
		});
		this.message = new Element('div',{
			'class':this.options.classPrefix+'Message',
			'styles':{
				'height':this.options.height,
				'width':this.options.width
			}
		});
		
	
		this.title = new Element('div',{
			'class':this.options.classPrefix+'Title'
		});

		this.close = new Element('div',{
			'class':this.options.classPrefix+'Close'
		}).adopt(new Element('img', {
					'src': this.options.closeBtn,
					'border': 0,
					'events': {
						'click': this.hide.bindWithEvent(this)
					}
				})
			).inject(this.title);
		
		this.container = new Element('div', {
			'class':this.options.classPrefix+'Container',
			'styles':{
				'margin':'0 auto',
				'width':this.options.width
			}
		}).adopt(this.title, this.close, this.message).inject(this.pop);
 
		//this.close.inject(this.container);
		//this.title.adopt(this.close);
 
		this.fade = new Fx.Tween(this.mask, {property: 'opacity', duration:this.options.speed});
		this.slide = new Fx.Tween(this.pop, {property: 'top', duration: this.options.speed});
		window.addEvents({
			'keydown': this.hide.bindWithEvent(this),
			'resize': this.resize.bindWithEvent(this),
			'scroll': this.scroll.bindWithEvent(this)
		});
		this.fireEvent('onStart');
	},
 
	show: function(el, options) {
		this.message.empty();
		
		switch($type(el)) {
			case 'element':
				this.message.adopt(el.clone().cloneEvents(el));
				break;
			case 'string':
				this.message.set('html', el);
				break;
			default:
				return false;
				break;
		}
		if(options && options.title){
			this.title.set('html',options.title);
		}else{
			this.title.empty();
		} 
		if(options && options.width){
			this.container.setStyle('width',options.width);
		}
		if(options && options.height){
			this.message.setStyle('height',options.height);
		}
		if(!this.isShowing){
			$$('object', 'select').setStyle('visibility', 'hidden');
			$(document.body).adopt(this.mask, this.pop);
			this.pop.setStyles({
				'top': window.getScroll().y - this.pop.getSize().y,
				'visibility':'visible'
			});
			this.fade.start(this.options.maskOpacity);
			this.isShowing = true;
			this.scroll();
			this.fireEvent('onShow');
		}
	},
 
	hide: function(e) {
		var event = new Event(e).stop();
		if((event.key && event.key != 'esc')||!this.isShowing){
			return;
		}
		$$('object', 'select').setStyle('visibility', 'visible');
		this.slide.cancel();
		var slideTo = - this.pop.getSize().y;
		this.slide.start(slideTo).chain(function() {
			this.pop.setStyle('visibility','hidden').dispose();
			this.fade.start(0).chain(function() {
				this.mask.dispose();
				this.isShowing = false;
				this.fireEvent('onHide');
			}.bind(this));
		}.bind(this));
	},
 
	resize: function(e){
		if(e){
			var event = new Event(e).stop();
		}
		(function(){
			this.mask.setStyles({
				'height': window.getScrollSize().y,
				'width': window.getScrollSize().x
			});
		}).delay(10,this);
		this.mask.setStyles({
			'height':window.getSize().y,
			'width':window.getSize().x
		});
		this.scroll();
		this.fireEvent('onResize');
	},
 
	scroll:function(e){
		if(e){
			var event = new Event(e).stop();
		}
		if(this.isShowing){
			(function(){
				var slideTo = ((window.getSize().y - this.container.getSize().y) / 2 + window.getScroll().y).toInt();
				this.slide.start(slideTo);
			}).delay(300,this);
			
		}
	}
});