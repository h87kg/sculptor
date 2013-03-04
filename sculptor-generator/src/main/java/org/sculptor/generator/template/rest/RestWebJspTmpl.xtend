package org.sculptor.generator.template.rest

import sculptormetamodel.*

import static extension org.sculptor.generator.ext.DbHelper.*
import static extension org.sculptor.generator.util.DbHelperBase.*
import static extension org.sculptor.generator.ext.Helper.*
import static extension org.sculptor.generator.util.HelperBase.*
import static extension org.sculptor.generator.ext.Properties.*
import static extension org.sculptor.generator.util.PropertiesBase.*

class RestWebJspTmpl {

def static String jsp(Application it) {
	'''
	�index(it)�
	�header(it)�
	�footer(it)�
	�includes(it)�
	�uncaughtException(it)�
	'''
}

def static String index(Application it) {
	'''
	'''
	fileOutput("index.jsp", 'TO_WEBROOT', '''
	<META http-equiv="refresh" content="0;URL=rest/front">
	'''
	)
	'''
	'''
}

def static String header(Application it) {
	'''
	'''
	fileOutput("WEB-INF/jsp/header.jsp", 'TO_WEBROOT', '''
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<style type="text/css" media="screen">   
		@import url("<c:url value="/stylesheets/main.css"/>");
		</style>     
		<title>TITLE</title>	
	</head>
	<body >	
		<div id="wrap">
		<div id="main">	
	'''
	)
	'''
	'''
}

def static String footer(Application it) {
	'''
	'''
	fileOutput("WEB-INF/jsp/footer.jsp", 'TO_WEBROOT', '''
	<br/>
	  <table class="footer">
	    <tr>
	      <td><a href="<c:url value="/rest/front" />">Home</a></td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	    </tr>
	  </table>

	</div>
		</div>
	</body>

	</html>
	'''
	)
	'''
	'''
}

def static String includes(Application it) {
	'''
	'''
	fileOutput("WEB-INF/jsp/includes.jsp", 'TO_WEBROOT', '''
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	'''
	)
	'''
	'''
}

def static String uncaughtException(Application it) {
	'''
	'''
	fileOutput("WEB-INF/jsp/uncaughtException.jsp", 'TO_WEBROOT', '''
	<h2/>Internal error</h2>
	<p/>

	<% 
	try {
	// The Servlet spec guarantees this attribute will be available
	Throwable exception = (Throwable) request.getAttribute("javax.servlet.error.exception"); 

	if (exception != null) {
		if (exception instanceof ServletException) {
			// It's a ServletException: we should extract the root cause
			ServletException sex = (ServletException) exception;
			Throwable rootCause = sex.getRootCause();
			if (rootCause == null)
				rootCause = sex;
			out.println("** Root cause is: "+ rootCause.getMessage());
			rootCause.printStackTrace(new java.io.PrintWriter(out)); 
		}
		else {
			// It's not a ServletException, so we'll just show it
			exception.printStackTrace(new java.io.PrintWriter(out)); 
		}
	} 
	else  {
			out.println("No error information available");
	} 

	// Display cookies
	out.println("\nCookies:\n");
	Cookie[] cookies = request.getCookies();
	if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
					out.println(cookies[i].getName() + "=[" + cookies[i].getValue() + "]");
		}
	}
	    
	} catch (Exception ex) { 
	ex.printStackTrace(new java.io.PrintWriter(out));
	}
	%>

	<p/>
	<br/>
	'''
	)
	'''
	'''
}

def static String jsp(Resource it) {
	'''
	�val postOperation = it.operations.selectFirst(e | e.httpMethod == HttpMethod::POST)�
	�val putOperation = it.operations.selectFirst(e | e.httpMethod == HttpMethod::PUT)�
	�val deleteOperation = it.operations.selectFirst(e | e.httpMethod == HttpMethod::DELETE)�
	�val createFormOperation = it.operations.selectFirst(e | e.httpMethod == HttpMethod::GET && e.name == "createForm" && e.returnString != null) �
	�val updateFormOperation = it.operations.selectFirst(e | e.httpMethod == HttpMethod::GET && e.name == "updateForm" && e.returnString != null) �
	�LET operations.reject(e | e == createFormOperation || e == updateFormOperation) .selectFirst(e | e.httpMethod == HttpMethod::GET && e.domainObjectType != null && e.collectionType == null && e.returnString != null)
		AS getOperation�
	�LET operations.reject(e | e == createFormOperation || e == updateFormOperation) .selectFirst(e | e.httpMethod == HttpMethod::GET && e.domainObjectType != null && e.collectionType != null && e.returnString != null)
		AS listOperation�
	
		�IF createFormOperation != null && postOperation != null�
			�createForm(it)(postOperation) FOR createFormOperation�
		�ENDIF�
		�IF updateFormOperation != null && putOperation != null�
			�updateForm(it)(putOperation) FOR updateFormOperation�
		�ENDIF�
		�IF getOperation != null�
			�show(it) FOR getOperation�
		�ENDIF�
		�IF listOperation != null�
			�list(it)(getOperation, updateFormOperation, deleteOperation, createFormOperation) FOR listOperation�
		�ENDIF�
		�emptyPage(it) FOREACH  operations.reject(e | e == createFormOperation || e == updateFormOperation || e == getOperation || e == listOperation)
					.filter(e | e.httpMethod == HttpMethod::GET && e.returnString != null && !e.returnString.startsWith("redirect:"))�
	'''
}

def static String emptyPage(ResourceOperation it) {
	'''
	'''
	fileOutput("WEB-INF/jsp/" + returnString + ".jsp", 'TO_WEBROOT', '''
	<jsp:directive.include file="/WEB-INF/jsp/includes.jsp"/>
	<jsp:directive.include file="/WEB-INF/jsp/header.jsp"/>
	<div>
	<p>
	TODO: page for �resource.name�.�name�  ...
	</p>
	�IF path == "/front"�
	<p>Resources:</p>
	<ul>
	�FOR r : resource.module.application.getAllResources(false).reject(e|e == this.resource)�
		<li><a href="<c:url value="/rest/�r.getDomainResourceName().toFirstLower()�" />">�r.getDomainResourceName().plural()�</a></li>
	�ENDFOR�
	</ul>
	�ENDIF�  
	</div>
	<jsp:directive.include file="/WEB-INF/jsp/footer.jsp"/>
	'''
	)
	'''
	'''
}

def static String createForm(ResourceOperation it, ResourceOperation postOperation) {
	'''
	'''
	fileOutput("WEB-INF/jsp/" + returnString + ".jsp", 'TO_WEBROOT', '''
	<jsp:directive.include file="/WEB-INF/jsp/includes.jsp"/>
	<jsp:directive.include file="/WEB-INF/jsp/header.jsp"/>
	<div>
	<h2>New �resource.getDomainResourceName()�</h2>
		<form:form action="/rest�postOperation.path�" method="POST" modelAttribute="�postOperation.parameters.first().name�">
		�val formClass = it.postOperation.parameters.filter(e | e.domainObjectType != null).collect(e|e.domainObjectType).first()�
			�IF formClass != null�
		�FOR att : formClass.attributes.filter(e | !e.isSystemAttribute())�
		<div id="�att.getDomainObject().name.toFirstLower()�_�att.name�">
				<label for="_�att.name�">�att.name.toFirstUpper()�:</label>
				<form:input cssStyle="width:300px" id="_�att.name�" path="�att.name�"/>
				<br/>
				<form:errors cssClass="errors" id="_�att.name�" path="�att.name�"/>
			</div>
		�ENDFOR�
			<div class="submit" id="�formClass.name.toFirstLower()�_submit">
				<input id="proceed" type="submit" value="Save"/>
			</div>
		�ENDIF�        
		</form:form>
	</div>
	<jsp:directive.include file="/WEB-INF/jsp/footer.jsp"/>
	'''
	)
	'''
	'''
}

def static String updateForm(ResourceOperation it, ResourceOperation putOperation) {
	'''
	'''
	fileOutput("WEB-INF/jsp/" + returnString + ".jsp", 'TO_WEBROOT', '''
	<jsp:directive.include file="/WEB-INF/jsp/includes.jsp"/>
	<jsp:directive.include file="/WEB-INF/jsp/header.jsp"/>
	<div>
	<h2>Edit �resource.getDomainResourceName()�</h2>
	�val formClass = it.putOperation.parameters.filter(e | e.domainObjectType != null).collect(e|e.domainObjectType).first()�
	�IF formClass != null�
		<form:form action="/rest�putOperation.path.replacePlaceholder('{id}', '${' + putOperation.parameters.first().name + '}' ) �" method="PUT" modelAttribute="�putOperation.parameters.first().name�">
			�FOR att : formClass.attributes�
			�IF att.isAuditableAttribute() �
			�ELSEIF !att.isChangeable() || att.isSystemAttribute()�
			<form:hidden path="�att.name�"/>
			�ELSE�
		<div id="�att.getDomainObject().name.toFirstLower()�_�att.name�">
				<label for="_�att.name�">�att.name.toFirstUpper()�:</label>
				<form:input cssStyle="width:300px" id="_�att.name�" path="�att.name�"/>
				<br/>
				<form:errors cssClass="errors" id="_�att.name�" path="�att.name�"/>
			</div>
			�ENDIF�
		�ENDFOR�
		<div class="submit" id="�formClass.name.toFirstLower()�_submit">
				<input id="proceed" type="submit" value="Save"/>
			</div>
		</form:form>
		�ENDIF�
	</div>
	<jsp:directive.include file="/WEB-INF/jsp/footer.jsp"/>
	'''
	)
	'''
	'''
}

def static String show(ResourceOperation it) {
	'''
	'''
	fileOutput("WEB-INF/jsp/" + returnString + ".jsp", 'TO_WEBROOT', '''
	<jsp:directive.include file="/WEB-INF/jsp/includes.jsp"/>
	<jsp:directive.include file="/WEB-INF/jsp/header.jsp"/>
	<div>
		<c:if test="${not empty result}">
			�IF domainObjectType != null�
			�FOR att : domainObjectType.attributes.filter(e | !e.isSystemAttribute())�
	        <div id="�resource.getDomainResourceName().toFirstLower()�_�att.name�">
	            <label for="_�att.name�">�att.name.toFirstUpper()�:</label>
	            <div class="box" id="_�att.name�">${result.�att.name�}</div>
	        </div>
	        <br/>
			�ENDFOR�
			�ENDIF�
		</c:if>
		<c:if test="${empty result}">No �resource.getDomainResourceName()� found with this id.</c:if>
	</div>
	<jsp:directive.include file="/WEB-INF/jsp/footer.jsp"/>
	'''
	)
	'''
	'''
}

def static String list(ResourceOperation it, ResourceOperation getOperation, ResourceOperation updateFormOperation, ResourceOperation deleteOperation, ResourceOperation createFormOperation) {
	'''
	'''
	fileOutput("WEB-INF/jsp/" + returnString + ".jsp", 'TO_WEBROOT', '''
	<jsp:directive.include file="/WEB-INF/jsp/includes.jsp"/>
	<jsp:directive.include file="/WEB-INF/jsp/header.jsp"/>
	�IF createFormOperation != null�
	<div>
	<a href="<c:url value="/rest�createFormOperation.path�" />">New �resource.getDomainResourceName()�</a>
	</div>
	�ENDIF�
	<div>
		<c:if test="${not empty result}">
		�IF domainObjectType != null�
		�val idAttribute = it.domainObjectType.getIdAttribute()�
		<table>
			<thead>
			�IF idAttribute != null�
	    	<th>�idAttribute.name.toFirstUpper()�</th>
			�ENDIF�
			�FOR att : domainObjectType.attributes.filter(e | !e.isSystemAttribute())�
				<th>�att.name.toFirstUpper()�</th>
			�ENDFOR�
			�IF getOperation != null�
				<th/>
			�ENDIF�
			�IF updateFormOperation != null�	
				<th/>
			�ENDIF�
			�IF deleteOperation != null�
				<th/>
			�ENDIF�
			</thead>
			<c:forEach items="${result}" var="each" >
				<tr>
					�IF idAttribute != null�
					<td>
						�IF getOperation != null�
						<a href="<c:url value="/rest�path�/${each.id�IF isJpaProviderAppEngine()�.id�ENDIF�}" />">${each.id�IF isJpaProviderAppEngine()�.id�ENDIF�}</a>
						�ELSE�
						${each.id�IF isJpaProviderAppEngine()�.id�ENDIF�}
						�ENDIF�
					</td>
					�ENDIF�
					�FOR att : domainObjectType.attributes.filter(e | !e.isSystemAttribute())�
					<td>
						${each.�att.name�}
					</td>
					�ENDFOR�
					�IF getOperation != null�
					<td>
						<a href="<c:url value="/rest�path�/${each.id�IF isJpaProviderAppEngine()�.id�ENDIF�}" />">Show</a>
				    </td>
				    �ENDIF�
				    �IF updateFormOperation != null�
					<td>
						<a href="<c:url value="/rest�path�/${each.id�IF isJpaProviderAppEngine()�.id�ENDIF�}/form" />">Edit</a>
					</td>
					�ENDIF�
					�IF deleteOperation != null�
					<td>
				        <form:form action="/rest�path�/${each.id�IF isJpaProviderAppEngine()�.id�ENDIF�}" method="DELETE">
				        	<input id="delete" type="submit" value="Delete"/>
				        </form:form>
				    </td>
				    �ENDIF�
				</tr>
			</c:forEach>
		</table>
		�ENDIF�
		</c:if>
		<c:if test="${empty result}"><p>There are no �resource.getDomainResourceName().plural()� yet.</p></c:if>
	</div>
	<jsp:directive.include file="/WEB-INF/jsp/footer.jsp"/>

	'''
	)
	'''
	'''
}

}
