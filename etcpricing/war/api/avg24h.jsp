<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="apiheader.jspf" %>
<%@ page import="java.util.*" %>    
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="com.etherpricing.model.*" %>
<%@ page import="com.etherpricing.objectify.ObjectifyManager"%>

<%!
public static final String CACHE_PREFIX = "avg24h";
/**
 * create standard cache key
 * @param timeMillis - epoch time, as in System.currentTimeMillis()
 */
private static String getCacheKey(long timeMillis) {
	return CACHE_PREFIX + timeMillis;
}

%>

<%
//
// show the price within 24h
//

long timeMillis = System.currentTimeMillis();
// todo: to further save the quota, i will use exact time minute time, 
// so this will only update cache every 10 minutes.
// i will want to change this back to per minute when i want to show more detailed data 
long wholeTime = TenMinute.calcWholeTime(timeMillis);
final long MILLIS_IN_ONE_DAY = 1000L * 60L * 60L * 24L;
final long MILLIS_IN_TEN_MINUTES = 1000L * 60L * 10L;
Date start = new Date(wholeTime - MILLIS_IN_ONE_DAY);
Date end = new Date(wholeTime);

// get from cache
String result = CacheManager.getString(getCacheKey(wholeTime));

if (result == null) {
	// if not, get data and fill cache
	
	// get data
	// note, this may not be able to get current time.  because it might take sometime for the index to get updated.
	List<TenMinute> tenmins = ObjectifyService.ofy()
	          .load()
	          .type(TenMinute.class)
	          .filter("timeslot >", start)
	          .filter("timeslot <=", end)
	          .order("timeslot")       // Most recent first - timestamp
	          .list();
	
	// convert to json array of array.
	// eg.
	//[
	//[1456728329000, 437.72],
	//[1456728332000, 437.71],
	//]
	
	JSONArray arrays = new JSONArray();
	for (TenMinute tenmin: tenmins) {
		JSONArray array = new JSONArray();
		array.put(tenmin.id);
		array.put(tenmin.average);
		arrays.put(array);
	}
	
	result = arrays.toString(2);
	
	CacheManager.save(getCacheKey(wholeTime), result);
	
	// delete earlier cached item
	long lastCacheTime = wholeTime - MILLIS_IN_TEN_MINUTES;
	CacheManager.delete(getCacheKey(lastCacheTime));
}
%>
<%=result%>