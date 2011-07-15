<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<div class="yui3-u-1">
	<div id="refresh">
		<img src="<spring:url value="images/arrow_refresh.png" />" />
	</div>
	<div>
		<c:forEach items="${packagequeue}" var="queue_item">
			<c:out value="${queue_item}" />
			<br />
		</c:forEach>
	</div>
	<div id="queue">
	</div>
	<div id="example1">
	</div>
	<div id="example2">
	</div>
</div>
<script type="text/javascript">

YUI({ useBrowserConsole: false,
	  filter: 'debug'}).use("dump","datasource-arrayschema" "datasource-get", "datasource-io", "datatable-base", "datasource-jsonschema", "datatable-datasource", "datasource-polling", 'overlay', 'console', function(Y) {
	
 	new Y.Console().render();
 	
 	var ds = new Y.DataSource.IO({
        source: "<spring:url value='/packages/queue/json'/>",
        ioConfig: {
            headers: { 'Accept': 'application/json'}
        }
    });
	var data = [{"date":"2011-07-15 17:28:29","path":"C:\\ProjectData\\BHL-Europe\\UnitTestResources\\title2","size":"3 KB","files":"4","user":"local"}];

	var myDataSource = new Y.DataSource.Local({source:data});

 	myDataSource.plug(Y.Plugin.DataSourceJSONSchema, {
        schema: {
            resultFields: [{key:"fruit",field:"date"}]
        }
    });
    
    var cols = ["date"];
 
    var table = new Y.DataTable.Base({
        columnset: cols
    });    
    
    table.plug(Y.Plugin.DataTableDataSource, {
        datasource: myDataSource
    }).render("#example1");    
    
    myDataSource.setInterval(1000, {
        request: "",
        callback: {
            success: function(e) {
            	// Y.bind(table.datasource.onDataReturnInitializeTable, table.datasource);
            	Y.log(Y.dump(e.response.results),"debug","pre-ingest")        	
            },
            failure: function(e) {
            	// Y.bind(table.datasource.onDataReturnInitializeTable, table.datasource);
            }
        }
    });
    
 // Creates a Columnset with 3 Columns. "cost" is not rendered.
    var cols1 = ["id","name","price"];
     
    // Columns must match data parameter names
    var data1 = [
        {id:"ga-3475", name:"gadget", price:"$6.99", cost:"$5.99"},
        {id:"sp-9980", name:"sprocket", price:"$3.75", cost:"$3.25"},
        {id:"wi-0650", name:"widget", price:"$4.25", cost:"$3.75"}
    ];
     
    // Creates a DataTable with 3 columns and 3 rows
    var table1 = new Y.DataTable.Base({
        columnset: cols1,
        recordset: data1
    }).render("#example2");


});

</script>