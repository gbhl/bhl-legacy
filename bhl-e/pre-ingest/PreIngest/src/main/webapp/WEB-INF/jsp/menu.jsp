<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<ul>
	<li class="yui3-menuitem"><a class="yui3-menuitem-content" href="<spring:url value ='/filebrowser/index' />">Submissions</a></li>
	<li class="yui3-menuitem"><a class="yui3-menuitem-content" href="<spring:url value ='/channels/index' />">Channels</a></li>
	<li class="yui3-menuitem"><a class="yui3-menuitem-content" href="#settings">My Settings</a></li>
	<li class="yui3-menuitem"><a class="yui3-menuitem-content" href="#support">Request Support</a></li>
	<li class="yui3-menuitem"><a class="yui3-menuitem-content" href="#contact">Contact</a></li>
	<li class="yui3-menuitem"><a class="yui3-menuitem-content" href="#about">About</a></li>
</ul>