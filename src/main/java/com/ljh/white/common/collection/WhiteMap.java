package com.ljh.white.common.collection;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;


import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class WhiteMap extends HashMap<String, Object> {

	private static final long serialVersionUID = 1587273999625657424L;
	private static final Logger logger = LoggerFactory.getLogger(WhiteMap.class);
	
	public WhiteMap(){
		super();
	}	
	
	public WhiteMap(HttpServletRequest request){		
				
		this.put("userId", request.getSession(false).getAttribute("userId").toString() == null ? null : request.getSession(false).getAttribute("userId").toString());
		this.put("userSeq", request.getSession(false).getAttribute("userSeq").toString() == null ? null : request.getSession(false).getAttribute("userSeq").toString());		
						
		Enumeration<String> enumeration = request.getParameterNames();
		
		while(enumeration.hasMoreElements()){
			String key = enumeration.nextElement();
			String values[] = request.getParameterValues(key);			
			
			if(values == null){
				this.put(key, null);	
			}else if(values.length <= 1){				
				this.put(key, values[0]);
			}else{
				this.put(key, values);			
			}	
		}
		logger.debug("url: "+request.getRequestURI());
		logger.debug("new WhiteMap(request): "+this);
	}
	
	public int getInt(String key){
		Object obj = this.get(key);		
		if(obj == null) return 0;
		else{
			return Integer.parseInt(obj.toString());
		}
		
	}
	
	public String getString(String key) {		
		Object obj = get(key);
		if (obj == null) return "";
		else{
			return obj.toString();
		}		
	}
	
	/**
	 * String Json convert WhiteMap
	 * @param String jsonStrParamKey
	 * @return
	 */
	public WhiteMap convertWhiteMap(String jsonStrParamKey, boolean isUserSeq) {
		if(this.getString(jsonStrParamKey) == null) return null;
		String jsonStr = this.getString(jsonStrParamKey);
		WhiteMap map = new WhiteMap();
		
		JSONObject jsonObj = new JSONObject(jsonStr);		
		Iterator<String> ite = jsonObj.keys();
		
		while(ite.hasNext()) {				
			String key = ite.next();				
			map.put(key, jsonObj.get(key));
		}
		if(isUserSeq) {
			map.put("userSeq", this.getInt("userSeq"));
		}
		return map;
	}
	
	/**
	 * String Json convert ListWhiteMap
	 * @param String jsonStrParamKey
	 * @return
	 */
	public List<WhiteMap> convertListWhiteMap(String jsonStrParamKey, boolean isUserSeq) {		
		if(this.getString(jsonStrParamKey) == null) return null;
		String jsonStr = this.getString(jsonStrParamKey);
		
		List<WhiteMap> list = new ArrayList<WhiteMap>();
		WhiteMap map = null;	
		
		JSONObject jsonObj = null;
		Iterator<String> ite = null;
		
		JSONArray jsonArr = new JSONArray(jsonStr);
		for(int i=0; i<jsonArr.length(); i++) {			
			map = new WhiteMap();
			
			jsonObj = new JSONObject(jsonArr.get(i).toString());
			ite = jsonObj.keys();
			
			while(ite.hasNext()) {				
				String key = ite.next();				
				map.put(key, jsonObj.get(key));
			}
			if(isUserSeq) {
				map.put("userSeq", this.getInt("userSeq"));
			}
			list.add(map);
		}		
		return list;
	}
	
	public WhiteMap deepCopy() {
		
		WhiteMap copyMap = new WhiteMap();
		
		Set<String> set = this.keySet();
		Iterator<String> ite = set.iterator();
		while(ite.hasNext()) {				
			String key = ite.next();
			copyMap.put(key, this.get(key));
		}		
		return copyMap;
	}
	
	public WhiteMap createKeyNewMap(String key) {
		WhiteMap map = new WhiteMap();
		map.put(key, this.get(key));
		return map; 
	}
}


