package com.ljh.white.common;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.Set;

import com.ljh.white.common.collection.WhiteMap;

/**
 *  공통메소드
 * @author jhkot
 *
 */

public class White {

	/**
	 * html태그 삭제 (String)
	 * @param data
	 * @return
	 */
	static public String htmlReplace(String str) {
		return str.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
	}
	
	/**
	 * html태그 삭제 (WhiteMap)
	 * @param data
	 * @return
	 */
	static public void htmlReplace(WhiteMap map) {
		
		Set<String> keys= map.keySet();		
		Iterator<String> ite = keys.iterator();
		
		while(ite.hasNext()) {				
			String key = ite.next();				
			map.put(key, White.htmlReplace(map.getString(key)));
		}
	}
	
	/**
	 * 날짜형식 체크
	 * @param date
	 * @return
	 */
	static public boolean dateCheck(String date) {		
		try {
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            df.setLenient(false);
            df.parse(date);
            return true;
        } catch (ParseException e) {
            return false;
        }
	}
	
	/**
	 * 날짜형식 체크(타입지정)
	 * @param date
	 * @return
	 */
	static public boolean dateCheck(String date, String type) {		
		try {
            DateFormat df = new SimpleDateFormat(type);
            df.setLenient(false);
            df.parse(date);
            return true;
        } catch (ParseException e) {
            return false;
        }
	}
}
