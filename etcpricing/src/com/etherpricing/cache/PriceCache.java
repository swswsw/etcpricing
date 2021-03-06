package com.etherpricing.cache;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import flexjson.JSONSerializer;

/**
 * contain an exchange's price to be stored in cache.  
 * 
 * @author sol wu
 *
 */
public class PriceCache implements Serializable {

	private static final long serialVersionUID = 2L;
	
	/**
	 * unlikely to have more than 10 ether currency pair in one exchange.
	 */
	private List<Price> priceList = new ArrayList<Price>(10);
	
	public List<Price> getPriceList() {
		return priceList;
	}

	public void setPriceList(List<Price> priceList) {
		this.priceList = priceList;
	}
	
	public String toString() {
		return "{ " + "\"priceList\": " + priceList +  " }";
	}

	/**
	 * price of one single currency pair
	 */
	public static class Price implements Serializable {
		/**
		 * 
		 */
		private static final long serialVersionUID = 1L;
		
		/** currency1 of currency pair */
		private String currency1 = null;
		/** currency2 of currency pair */
		private String currency2 = null;
		
		/** last price */
		private double last = -1;
		/** 24h volume */
		private double volume = -1;
		
		/** time of the price */
		private long time = 0L;
		/** exchange name */
		private String exchange = null;
		
		public Price(String currency1, String currency2, double last, double volume, long time, String exchange) {
			this.currency1 = currency1;
			this.currency2 = currency2;
			this.last = last;
			this.volume = volume;
			this.time = time;
			this.exchange = exchange;
		}
		
		public String toString() {
			// exclude class name.
			return new JSONSerializer().exclude("*.class").serialize(this); 
		}

		public String getCurrency1() {
			return currency1;
		}

		public void setCurrency1(String currency1) {
			this.currency1 = currency1;
		}

		public String getCurrency2() {
			return currency2;
		}

		public void setCurrency2(String currency2) {
			this.currency2 = currency2;
		}

		public double getLast() {
			return last;
		}

		public void setLast(double last) {
			this.last = last;
		}

		public double getVolume() {
			return volume;
		}

		public void setVolume(double volume) {
			this.volume = volume;
		}

		public long getTime() {
			return time;
		}

		public void setTime(long time) {
			this.time = time;
		}

		public String getExchange() {
			return exchange;
		}

		public void setExchange(String exchange) {
			this.exchange = exchange;
		}
		
		
	}
}
