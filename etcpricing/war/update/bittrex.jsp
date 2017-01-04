<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="updateheader.jspf" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.etherpricing.net.*" %>
<%@ page import="com.etherpricing.cache.*" %>
<%@ page import="org.json.*" %>
<%
JSONObject json = null;
try {
	json = RetrieveData.jsonData("https://bittrex.com/api/v1.1/public/getmarketsummaries");
} catch (SocketTimeoutException ex) {
	// sometimes, timeout can occur
	throw ex;
}

final long time = System.currentTimeMillis();
final String bittrex = "Bittrex";

List<JSONObject> etcTickers = new ArrayList<JSONObject>(5);
if (json != null) {
	boolean success = json.getBoolean("success");
	if (success) {
		JSONArray tickers = json.getJSONArray("result");
		if (tickers != null) {
			int length = tickers.length();
			for (int i=0; i<length; i++) {
				JSONObject ticker = tickers.getJSONObject(i);
				String currencyPair = ticker.getString("MarketName");
				if (currencyPair != null) {
					if (currencyPair.startsWith("ETC") || currencyPair.endsWith("ETC")) {
						etcTickers.add(ticker);
					}
				}
			}
		}
	}
}
  
PriceCache pc = new PriceCache();
for (int i=0; i<etcTickers.size(); i++) {
	JSONObject etcTicker = etcTickers.get(i);
	// eg. currencyPair = "BTC-ETC".  each currency may be more than 3 characters.
	String currencyPair = etcTicker.getString("MarketName");
	String[] currencies = currencyPair.split("-"); // separated by "-""
	// note we have to flip currency1 and currency2
	String currency1 = currencies[1];
	String currency2 = currencies[0];
	// this works for BTC-ETC, not for ETC-BTC pair.  last and volume would be incorrect.
	if ("ETC".equals(currency1)) {
		PriceCache.Price price = new PriceCache.Price(currency1, currency2, 
				etcTicker.getDouble("Last"), etcTicker.getDouble("Volume"), time, bittrex);
		pc.getPriceList().add(price);
	} else if ("ETC".equals(currency2)) {
		// if it is "ETC-BTC" instead of "BTC-ETC", we need to recalculate last and volume.
		// not sure how to do this yet
		//double nonBtcLast = etcTicker.getDouble("Last");
		//double btcLast = 0L;// how to calculate this?
		//double nonEtcVolume = etcTicker.getDouble("Volume");
		//double etcVolume = nonEtcVolume / nonBtcLast; // wait, this might not be correct
		//PriceCache.Price price = new PriceCache.Price(currency1, currency2, 
		//		btcLast, etcVolume, time, bittrex);
		//pc.getPriceList().add(price);
	}
	
}

CacheManager.save("latest_bittrex", pc);
%>
<%=pc%>