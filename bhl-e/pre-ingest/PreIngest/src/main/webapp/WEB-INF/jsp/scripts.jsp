<script src='${pageContext.request.contextPath}/resources/jquery/jquery.js' type='text/javascript'></script>
<script src='${pageContext.request.contextPath}/resources/jquery/jquery-ui.custom.js' type='text/javascript'></script>
<script src='${pageContext.request.contextPath}/resources/dynatree/jquery.dynatree.js' type='text/javascript'></script>

<!-- Add code to initialize the tree when the document is loaded: -->
<script type='text/javascript'>
$(function(){
    $("#tree").dynatree({
    	checkbox: true,
    	selectMode: 2,
        onActivate: function(node) {
            alert("You activated " + node);
        },
	    initAjax: {url: "${pageContext.request.contextPath}/filebrowser/ajaxTree",
               data: {key: "root", // Optional arguments to append to the url
                      mode: "all"
                      }
               },
        onLazyRead: function(node){
            node.appendAjax({url: "${pageContext.request.contextPath}/filebrowser/sendData",
                               data: {"key": node.data.key, // Optional url arguments
                                      "mode": "all"
                                      }
                              });
        }
    });
});

</script>

<!-- Include the required JavaScript libraries: -->
<script src="http://yui.yahooapis.com/3.3.0/build/yui/yui.js"></script>

<script type='text/javascript'>
//Call the "use" method, passing in "node-menunav".  This will load the
//script and CSS for the MenuNav Node Plugin and all of the required
//dependencies.

YUI({ filter: 'raw' }).use("node-menunav", function(Y) {

	//  Retrieve the Node instance representing the root menu
	//  (<div id="productsandservices">) and call the "plug" method
	//  passing in a reference to the MenuNav Node Plugin.
	
	var menu = Y.one("#menu");
	menu.plug(Y.Plugin.NodeMenuNav);
	menu.get("ownerDocument").get("documentElement").removeClass("yui3-loading");

});
YUI().use('tabview', function(Y) {
    var tabview = new Y.TabView({
        srcNode: '#contenttabs'
    });
 
    tabview.render();
    
	// finally set a listener for a tab selection change
	tabview.on("selectionChange", function(e) {

		var tabSelected = e.newVal.get("index");
		var channelSelected = null;

		switch (tabSelected) {
		case 0:
			channelSelected = "loading_ramp";
			break;
		case 1:
			channelSelected = "techmetadata";
			break;
		case 2:
			channelSelected = "boxing";
			break;
		case 3:
			channelSelected = "create_aip";
			break;
		}
		
	    $.getJSON("${pageContext.request.contextPath}/filebrowser/status/objects",
			    {
			     channel: channelSelected
			    },
			   	function(data) {
			    	setObjectInfo(data, tabSelected);
			    });
	    
	    function setObjectInfo(data, tab) {
	    	  var tabcontent = "";
	    	  
	    	  $.each(data, function(i,value){	    	
	    	    tabcontent += "<li>"+line(value)+"</li>";
	    	  });
	    	  
	    	  function line(data) {
	    		  var line = "";
	    		  var separator = " - ";
		    	  $.each(data, function(k,item){		    		  
			    	    line += item;
			    	    if (k <= data.length-2) line += separator;	    		  
			      });
		    	  return line;
	    	  }
	    	  
  			switch (tab) {
			case 0:
				content = "#loadingcontent ul";
				break;
			case 1:
				content = "#splittercontent ul";
				break;
			case 2:
				content = "#aggregatorcontent ul";
				break;
			case 3:
				content = "#wrapupcontent ul";
				break;
			}
	    	$(content).html(tabcontent);
	    	};
	});    
    
});
</script>