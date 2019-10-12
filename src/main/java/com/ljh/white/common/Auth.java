package com.ljh.white.common;

import java.util.List;

import com.ljh.white.common.collection.WhiteMap;

/**
 * 권한, 메모리 저장
 * @author jhkot
 *
 */
public class Auth {
	
	private static WhiteMap upperAuth = null;
	private static WhiteMap lowerAuth = null;

	public static WhiteMap getUpperAuth() {
		return upperAuth;
	}

	public static void setUpperAuth(WhiteMap upperAuth) {
		Auth.upperAuth = upperAuth;
	}
	public static void setUpperAuth(List<WhiteMap> upperAuthList) {
		WhiteMap upperAuth = new WhiteMap();
		for(int i=0; i< upperAuthList.size(); i++) {
			upperAuth.put(upperAuthList.get(i).getString("upperUrl"), upperAuthList.get(i).getString("authNm"));
		}
		Auth.setUpperAuth(upperAuth);
	}
	
	public static WhiteMap getLowerAuth() {
		return lowerAuth;
	}

	public static void setLowerAuth(WhiteMap lowerAuth) {
		Auth.lowerAuth = lowerAuth;
	}
	public static void setLowerAuth(List<WhiteMap> lowerAuthList) {
		WhiteMap lowerAuth = new WhiteMap();
		for(int i=0; i< lowerAuthList.size(); i++) {
			lowerAuth.put(lowerAuthList.get(i).getString("lowerUrl"), lowerAuthList.get(i).getString("authNm"));
		}
		Auth.setLowerAuth(lowerAuth);
	}

}
