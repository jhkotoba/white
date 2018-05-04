package com.ljh.white.common.collection;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

public class WhiteMap extends HashMap<String, Object> {

	private static final long serialVersionUID = 1587273999625657424L;
	private static Logger logger = LogManager.getLogger(WhiteMap.class);
	
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
		
		//if("".equals(this.getString("sideUrl"))) this.put("sideUrl", "/index");
		
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
	
	public WhiteMap getWhiteMap(String paramKey) {
		if(this.getString(paramKey) == null) return null;
		String jsonStr = this.getString(paramKey);
		WhiteMap map = new WhiteMap();
		
		JSONObject jsonObj = new JSONObject(jsonStr);		
		Iterator<String> ite = jsonObj.keys();
		
		while(ite.hasNext()) {				
			String key = ite.next();				
			map.put(key, jsonObj.get(key));
		}
		return map;
	}
	
	public List<WhiteMap> getListWhiteMap(String paramKey) {		
		if(this.getString(paramKey) == null) return null;
		String jsonStr = this.getString(paramKey);
		
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
}


