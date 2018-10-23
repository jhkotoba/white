package com.ljh.white.common;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.springframework.mobile.device.Device;

import com.ljh.white.common.collection.WhiteMap;

/**
 *  공통메소드
 * @author jhkot
 *
 */

public class White {
	
	/**
	 * 접속기기 구분
	 * @param device
	 * @return
	 */
	static public String device(Device device) {
		if(device.isNormal()) {
			return "normal";
		}else {
			//return "mobile";
			return "normal";
		}
	}

	/**
	 * html태그 삭제 (String)
	 * @param data
	 * @return
	 */
	static public String htmlReplace(String str) {
		return str.replaceAll("<(/)?([a-zA-Z0-6]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
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
		return White.dateCheck(date, null);
	}
	
	/**
	 * 날짜형식 체크(타입지정)
	 * @param date
	 * @return
	 */
	static public boolean dateCheck(String date, String type) {
		
		if("".equals(type) || type == null) {
			type = "yyyy-MM-dd";
		}
		
		try {
            DateFormat df = new SimpleDateFormat(type);
            df.setLenient(false);
            df.parse(date);
            return true;
        } catch (ParseException e) {
            return false;
        }
	}
	
	/**
	 * ListWhiteMap 에서 지정된 Key와 value를 바탕으로 WhiteMap 객체 생성
	 * @return
	 */
	static public WhiteMap convertListToMap(List<WhiteMap> list, String keyNm, String valueNm) {
		WhiteMap map = new WhiteMap();
		
		for(int i=0; i<list.size(); i++) {
			map.put(list.get(i).getString(keyNm), list.get(i).getString(valueNm));
		}
		return map;
	}
	
	/**
	 * null 데이터 빈 스트링 으로 변환
	 * @param str
	 * @return
	 */
	static public String nullDelete(String str) {
		if(str == null) {
			return "";
		}else {
			return str;
		}
	}
	
	/**
	 * null 데이터 빈 스트링 으로 변환(Map)
	 * @param str
	 * @return
	 */
	static public void nullDelete(WhiteMap map) {
		
		Set<String> keys= map.keySet();		
		Iterator<String> ite = keys.iterator();
		
		while(ite.hasNext()) {				
			String key = ite.next();				
			map.put(key, White.nullDelete(map.getString(key)));
		}
	}
}
