/* $Id: greybox.js,v 1.2 2008/12/04 11:32:23 Gurpartap Exp $ */

/**
 * Greybox Redux
 * jQuery is required (included in Drupal 5): http://jquery.com/
 * Written by: John Resig
 * License: GPL
 */

var GB_DONE = false;
var GB_SITEPATH = null;
var GB_HEIGHT = null;
var GB_WIDTH = null;

Drupal.behaviors.greybox = function() {
  GB_SITEPATH = Drupal.settings.greybox.path;

  var windowHeight = self.innerHeight ||
    jQuery.boxModel && document.documentElement.clientHeight ||
    document.body.clientHeight || 600;
  var windowWidth = self.innerWidth ||
    jQuery.boxModel && document.documentElement.clientWidth ||
    document.body.clientWidth || 800;

  $('a.' + Drupal.settings.greybox.class_text).bind('click', function(){
    var title = this.title || $(this).text() || this.href;
    var dims = $(this).attr('rel');
    dims = dims.split(/x/i, 2);

    GB_WIDTH = dims[0] || Drupal.settings.greybox.gbwidth || Math.round(windowWidth - (windowWidth/100)*10);
    GB_HEIGHT = dims[1] || Drupal.settings.greybox.gbheight || Math.round(windowHeight - (windowHeight/100)*10);

    GB_show(title, this.href);
    return false;
  });
}

function GB_show(caption, url) {
  if(!GB_DONE) {
    $(document.body)
      .append("<div id='GB_overlay'></div><div id='GB_window'><div id='GB_caption'></div>"
      + "<img src='"+ GB_SITEPATH + "/images/close.gif' alt='Close window'/></div>");
    $("#GB_window img").click(GB_hide);
    $("#GB_overlay").click(GB_hide);
    $(window).resize(GB_position);
    $(window).scroll(GB_position);
    GB_DONE = true;
  }
  $("#GB_frame").remove();
  $("#GB_window").append("<iframe id='GB_frame' src='" + url + "'></iframe>");

  $("#GB_caption").html(caption);
  $("#GB_overlay").fadeIn(350);
  GB_position();

  $("#GB_window").css({ height: 0, width: 0 }).animate({ height: GB_HEIGHT, width: GB_WIDTH, opacity: 1 }, 350, GB_position);

  $('body').css('overflow', 'hidden');

  /*
  var left = document.all ? iebody.scrollLeft : pageXOffset;
  var top = document.all ? iebody.scrollTop : pageYOffset;
	
  $(document).bind('scroll', function() {
    scrollTo(left, top);
  });
  */
}

function GB_hide() {
  $("#GB_window").animate({ height: 0, width: 0, opacity: 0 }, 350);
  $("#GB_overlay").fadeOut(350, function() {
    $('body').css('overflow', 'auto');
  });
}

// Keep Greybox Window centered regardless of window scroll.
// Code from http://jquery.com/blog/2006/02/10/greybox-redux/
function GB_position() {
  var de = document.documentElement;
  var h = self.innerHeight || (de && de.clientHeight) || document.body.clientHeight;
  var w = self.innerWidth || (de && de.clientWidth) || document.body.clientWidth;
  var iebody = (document.compatMode && document.compatMode != "BackCompat") ? document.documentElement : document.body;
  var dsocleft = document.all? iebody.scrollLeft : pageXOffset;
  var dsoctop = document.all? iebody.scrollTop : pageYOffset;
    
  var height = h < GB_HEIGHT ? h - 32 : GB_HEIGHT;
  var top = (h - height)/2 + dsoctop;

  $("#GB_window, #GB_frame").css({ width: GB_WIDTH + "px", height: height + "px",
    left: ((w - GB_WIDTH)/2) +"px", top: top + "px" });
  $("#GB_frame").css("height", height - 32 + "px");
}
