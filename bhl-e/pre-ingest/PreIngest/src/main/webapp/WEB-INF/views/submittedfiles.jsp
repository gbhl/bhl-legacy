<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h1>
	Submitted Files List
</h1>

<c:forEach items="${fileList}" var="file_item">
	<c:out value="${file_item}"/><br/>
</c:forEach>

