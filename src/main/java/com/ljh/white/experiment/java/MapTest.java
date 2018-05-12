package com.ljh.white.experiment.java;

import com.ljh.white.common.collection.WhiteMap;

public class MapTest {

	public static void main(String[] args) {
		

		WhiteMap map = new WhiteMap();
		
		map.put("1", "test1");
		map.put("2", "test2");
		map.put("3", "test3");
		
		
		System.out.println(map.get("1"));
		System.out.println(map.get("2"));
		System.out.println(map.get("3"));
		System.out.println(map.get("4"));
		
		if(map.get("4")==null) {
			System.out.println("map4 IS NULL");
		}
		
		
	}

}
