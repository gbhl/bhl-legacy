function popupWin_NAMES(theString,mouseX,mouseY)
{
  mouseX = mouseX-77;
  mouseY = mouseY-180;
  newTarget_NAMES('http://names.ubio.org/tools/recognize_popup.php?string='+theString, 'top='+mouseY+',left='+mouseX+',width=150,height=50,resizable=0,scrollbars=0,status=0');
}

function newTarget_NAMES(page, features, windowName) 
{
  newwin=window.open(page, windowName, features);
  if (newwin.opener==null) newwin.opener=window;
  newwin.opener.name = "opener";
  newwin.focus();	
}                

function togNode_NAMES(strNodeID)
{
  var node  = document.getElementById(strNodeID);
  var style = node.style.display;

  if (style == "none")
  {
      node.style.display = "block";
  }
  else
  {
      node.style.display = "none";
  }
}

function submitClassification_NAMES()
{
  newwin=window.open("","classification_NAMES","width=700,height=400,top=200,left=200,toolbar=yes,scrollbars=yes,resizable=1");
  if (newwin.opener==null) newwin.opener=window;
  newwin.opener.name = "opener";
  document.classification_NAMES.submit();
}

/***********************************************
* AnyLink Drop Down Menu- © Dynamic Drive (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for full source code
***********************************************/
		
var menuwidth='165px' //default menu width
var menubgcolor='white'  //menu bgcolor
var disappeardelay=250  //menu disappear speed onMouseout (in miliseconds)
var hidemenu_onclick="yes" //hide menu when user clicks within menu?

/////No further editting needed

var ie4=document.all
var ns6=document.getElementById&&!document.all

if (ie4||ns6)
document.write('<div id="dropmenudiv" style="visibility:hidden;width:'+menuwidth+';background-color:'+menubgcolor+'" onMouseover="clearhidemenu()" onMouseout="dynamichide(event)"></div>')

function getposOffset(what, offsettype)
{
  var totaloffset=(offsettype=="left")? what.offsetLeft : what.offsetTop;
  var parentEl=what.offsetParent;
  while (parentEl!=null)
  {
    totaloffset=(offsettype=="left")? totaloffset+parentEl.offsetLeft : totaloffset+parentEl.offsetTop;
    parentEl=parentEl.offsetParent;
  }
  return totaloffset;
}

function showhide(obj, e, visible, hidden, menuwidth)
{
  if (ie4||ns6)
    dropmenuobj.style.left=dropmenuobj.style.top=-500
  if (menuwidth!="")
  {
    dropmenuobj.widthobj=dropmenuobj.style
    dropmenuobj.widthobj.width=menuwidth
  }
  if (e.type=="click" && obj.visibility==hidden || e.type=="mouseover")
    obj.visibility=visible
  else if (e.type=="click")
    obj.visibility=hidden
}

function iecompattest()
{
  return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function clearbrowseredge(obj, whichedge)
{
  var edgeoffset=0
  if (whichedge=="rightedge")
  {
    var windowedge=ie4 && !window.opera? iecompattest().scrollLeft+iecompattest().clientWidth-15 : window.pageXOffset+window.innerWidth-15
    dropmenuobj.contentmeasure=dropmenuobj.offsetWidth
    if (windowedge-dropmenuobj.x < dropmenuobj.contentmeasure)
      edgeoffset=windowedge-dropmenuobj.x-dropmenuobj.contentmeasure-5
  }
  else
  {
    var topedge=ie4 && !window.opera? iecompattest().scrollTop : window.pageYOffset
    var windowedge=ie4 && !window.opera? iecompattest().scrollTop+iecompattest().clientHeight-15 : window.pageYOffset+window.innerHeight-18
    dropmenuobj.contentmeasure=dropmenuobj.offsetHeight
    if (windowedge-dropmenuobj.y < dropmenuobj.contentmeasure)
    { //move up?
      edgeoffset=dropmenuobj.contentmeasure+obj.offsetHeight
      if ((dropmenuobj.y-topedge)<dropmenuobj.contentmeasure) //up no good either?
        edgeoffset=dropmenuobj.y+obj.offsetHeight-topedge
    }
  }
  return edgeoffset
}

function populatemenu(what)
{
  if (ie4||ns6)
    dropmenuobj.innerHTML=what.join("")
}


function dropdownmenu(obj, e, menucontents, menuwidth)
{
  if (window.event) 
    event.cancelBubble=true
  else if (e.stopPropagation) e.stopPropagation()
    clearhidemenu()
  dropmenuobj=document.getElementById? document.getElementById("dropmenudiv") : dropmenudiv
  populatemenu(menucontents)

  if (ie4||ns6)
  {
    showhide(dropmenuobj.style, e, "visible", "hidden", menuwidth)
    dropmenuobj.x=getposOffset(obj, "left")
    dropmenuobj.y=getposOffset(obj, "top")
    dropmenuobj.style.left=dropmenuobj.x+clearbrowseredge(obj, "rightedge")+"px"
    dropmenuobj.style.top=dropmenuobj.y-clearbrowseredge(obj, "bottomedge")+obj.offsetHeight+"px"
  }

  return clickreturnvalue()
}

function clickreturnvalue()
{
  if (ie4||ns6) return false
    else return true
}

function contains_ns6(a, b) 
{
  while (b.parentNode)
    if ((b = b.parentNode) == a)
      return true;
    return false;
}

function dynamichide(e)
{
  if (ie4&&!dropmenuobj.contains(e.toElement))
    delayhidemenu()
  else if (ns6&&e.currentTarget!= e.relatedTarget&& !contains_ns6(e.currentTarget, e.relatedTarget))
    delayhidemenu()
}

function hidemenu(e)
{
  if (typeof dropmenuobj!="undefined")
  {
    if (ie4||ns6)
      dropmenuobj.style.visibility="hidden"
  }
}

function delayhidemenu()
{
  if (ie4||ns6)
    delayhide=setTimeout("hidemenu()",disappeardelay)
}

function clearhidemenu()
{
  if (typeof delayhide!="undefined")
    clearTimeout(delayhide)
}

if (hidemenu_onclick=="yes")
  document.onclick=hidemenu
