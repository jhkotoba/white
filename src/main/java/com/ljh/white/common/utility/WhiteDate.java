package com.ljh.white.common.utility;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class WhiteDate {
	
	private static Logger logger = LogManager.getLogger(WhiteDate.class);
	public static SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	
	/**
	 * String yyyy-MM-dd HH:mm:ss 형식으로 된 문자열을 각각 나눠서 List<Integer>로 저장후 반환
	 * @param String yyyy-MM-dd HH:mm:ss
	 * @return List yyyy, MM, dd, HH, mm, ss
	 */
	public static List<Integer> dateStrConvertIntList(String date){
		
		List<Integer> list = new ArrayList<Integer>();
		String[] dataArr = date.split(" ");
		list.add(Integer.parseInt(dataArr[0].split("-")[0]));
		list.add(Integer.parseInt(dataArr[0].split("-")[1]));
		list.add(Integer.parseInt(dataArr[0].split("-")[2]));
		
		list.add(Integer.parseInt(dataArr[1].split(":")[0]));
		list.add(Integer.parseInt(dataArr[1].split(":")[1]));
		list.add(Integer.parseInt(dataArr[1].split(":")[2]));
		
		return list;
	}
	
	/**
	 *  문자열 yyyy-MM-dd HH:mm:ss 형식으로 날짜와 밀리초를 계산하여   
	 *  문자열(yyyy-MM-dd HH:mm:ss)형식으로 반환
	 */
	public static String dateCalculate(String date, long millisecond) {
		long value = 0;
		try {
			value = simpleDateFormat.parse(date).getTime();
		} catch (ParseException e) {
			logger.error("날짜 데이터 ["+date+"]가 형식에(yyyy-MM-dd HH:mm:ss) 맞지 않음");
			e.printStackTrace();
		}
		return simpleDateFormat.format(value + millisecond);
	}
	
	
	
}
