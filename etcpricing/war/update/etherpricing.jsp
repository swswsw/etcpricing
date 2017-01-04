<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
// get etherpricing prices
// http://etherpricing.com/api/average.jsp

JSONObject json = null;
try {
	json = RetrieveData.jsonData("http://etherpricing.com/api/average.jsp");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

if (json != null) {	
	CacheManager.save("latest_etherpricing", json.toString());
}
%>
<%=(json != null) ? json.toString(2) : null %>