<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >
<head>
	<title>Print Biodiversity Heritage Library Image</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>
<body onload="javascript:window.print();javascript:window.close();">
	<img src="<% out.println(request.getParameter("imageURL")); %>" border="0" alt="Loading image..." title="Image" style="width:672px;height:912px;" />
</body>
</html>
