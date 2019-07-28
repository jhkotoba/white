package com.ljh.white.common;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
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
		
		if(date == null) return false;
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
	
	/**
	 * 오늘날짜 yyyy-MM-dd
	 * @return
	 */
	static public String getTodayDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
        return sdf.format(cal.getTime());
	}
	
	/**
	 * 오늘날짜 yyyy-MM-dd HH:mm:ss
	 * @return
	 */
	static public String getTodayDateTime() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
        return sdf.format(cal.getTime());
	}
	
	/**
	 * 입력받은 날짜에서 받은숫자만큼 월 감소
	 * @param fromDate
	 * @param addMonth
	 * @return
	 */
	static public String dateMonthCalculate(String fromDate, int addMonth) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		String result = null;
		try {			
			cal.setTime(sdf.parse(fromDate));
			cal.add(Calendar.MONTH, addMonth);
			result = sdf.format(cal.getTime());
		} catch (ParseException e) {			
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 현재시간 HH:mm:ss
	 * @return
	 */
	static public String getNowTime() {
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        Calendar c1 = Calendar.getInstance();
        return sdf.format(c1.getTime());
	}
	
	/**
	 * 입력받은 날짜를 첫날로 반환
	 * @param date
	 * @return
	 */
	static public String getFirstDate(String date) {
		String[] split = date.split("-");
		if(split.length == 3) {
			return split[0]+"-"+split[1]+"-"+"01";
		}else {
			return null;
		}
	}
	
	/**
	 * 입력받은 날짜를 마지막날로 반환
	 * @param date
	 * @return
	 */
	static public String getLastDate(String date) {		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();        
        try {			
			String[] split = date.split("-");
			
			cal.setTime(sdf.parse(date));
			int lastDay = cal.getActualMaximum(Calendar.DATE);
			
			return split[0]+"-"+split[1]+"-"+(lastDay < 10 ? lastDay+"0":lastDay);
		} catch (ParseException e) {			
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * "", null 이면 true 아니면 false 
	 * @param str
	 * @return
	 */
	static public boolean isEmpty(Object obj) {
		return White.isEmpty(obj.toString());
	}
	static public boolean isEmpty(String str) {
		if("".equals(str) || str == null) {
			return true;
		}else {
			return false;
		}
	}
	
	/**
	 * "", null 이면 null,  아니면  toString 해서 반환 
	 * @param str
	 * @return
	 */
	static public String isEmptyRtn(Object obj) {
		return White.isEmptyRtn(obj.toString());
	}
	static public String isEmptyRtn(String str) {
		if("".equals(str) || str == null) {
			return null;
		}else {
			return str.toString();
		}
	}
}
