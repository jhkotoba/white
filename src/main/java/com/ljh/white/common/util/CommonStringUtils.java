package com.ljh.white.common.util;

public class CommonStringUtils {
	
	/*
	 * 문자열이 모두 대문자인지 체크
	 */
	public static boolean isAllUpper(String string) {
	    for(char character : string.toCharArray()) {
	       if(Character.isLetter(character) && Character.isLowerCase(character)) {
	           return false;
	        }
	    }
	    return true;
	}
}
