<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject json = RetrieveData.jsonData("https://poloniex.com/public?command=returnTicker");
final long time = System.currentTimeMillis();
final String poloniex = "Poloniex"; 
PriceCache pc = new PriceCache();
if (json != null) {
	JSONObject btcetc = json.getJSONObject("BTC_ETC");
	JSONObject ethetc = json.getJSONObject("ETH_ETC");
	JSONObject usdtetc = json.getJSONObject("USDT_ETC");
	
	// weird, currency pair means first currency = this much second currency.  
	// eg. eth_btc price of 0.0020 means  1 eth = 0.0020 btc
	// but poloniex seems to flip the price (flip around first and second currency)
	// we want to normalize the notation, so we will flip first and second currency.
	
	// we want quoteVolume as the unit is in etc
	PriceCache.Price btcetcPrice = 
		new PriceCache.Price("ETC", "BTC", btcetc.getDouble("last"), btcetc.getDouble("quoteVolume"), time, poloniex);
	
	PriceCache.Price ethetcPrice = 
			new PriceCache.Price("ETC", "ETH", ethetc.getDouble("last"), ethetc.getDouble("quoteVolume"), time, poloniex);
	
	PriceCache.Price usdtetcPrice = 
		new PriceCache.Price("ETC", "USDT", usdtetc.getDouble("last"), usdtetc.getDouble("quoteVolume"), time, poloniex);
	
	pc.getPriceList().add(btcetcPrice);
	pc.getPriceList().add(ethetcPrice);
	pc.getPriceList().add(usdtetcPrice);
	
	CacheManager.save("latest_poloniex", pc);
}
%>
<%=pc%>