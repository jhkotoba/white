package com.ljh.white.common;

import java.util.List;

import com.ljh.white.common.collection.WhiteMap;

public class StaticValue {
	
	private static WhiteMap navAuth = null;
	private static WhiteMap sideAuth = null;

	public static WhiteMap getNavAuthList() {
		return navAuth;
	}

	public static void setNavAuth(WhiteMap navAuth) {
		StaticValue.navAuth = navAuth;
	}
	public static void setNavAuth(List<WhiteMap> navAuthList) {
		WhiteMap navAuth = new WhiteMap();
		for(int i=0; i< navAuthList.size(); i++) {
			navAuth.put(navAuthList.get(i).getString("navUrl"), navAuthList.get(i).getString("authNm"));
		}
		StaticValue.setNavAuth(navAuth);
	}
	
	public static WhiteMap getSideAuthList() {
		return sideAuth;
	}

	public static void setSideAuth(WhiteMap sideAuth) {
		StaticValue.sideAuth = sideAuth;
	}
	public static void setSideAuth(List<WhiteMap> sideAuthList) {
		WhiteMap sideAuth = new WhiteMap();
		for(int i=0; i< sideAuthList.size(); i++) {
			sideAuth.put(sideAuthList.get(i).getString("sideUrl"), sideAuthList.get(i).getString("authNm"));
		}
		StaticValue.setSideAuth(sideAuth);
	}

}
