package com.ljh.white.common;

import java.util.List;

import com.ljh.white.common.collection.WhiteMap;

public class StaticValue {
	
	private static WhiteMap navAuth = null;

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

}
