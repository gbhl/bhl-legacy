<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<div class="yui3-u-1">
	<div id="refresh">
		<img src="<spring:url value="images/arrow_refresh.png" />" />
	</div>
	<div>
		<c:forEach var="entry" items="${packageMap}">
		    Name:  ${entry.key}
		    Value: ${entry.value}<br>
		</c:forEach>
	</div>
</div>