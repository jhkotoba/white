package com.ljh.white.common.collection;

import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.ljh.white.ledger.mapper.LedgerMapper;

public class WhiteMap extends HashMap<String, Object> {

	private static final long serialVersionUID = 1587273999625657424L;
	private static Logger logger = LogManager.getLogger(LedgerMapper.class);
	
	public WhiteMap(){
		super();
	}	
	
	public WhiteMap(HttpServletRequest request){
		
		String userId = request.getSession(false).getAttribute("userId").toString();		
		
		this.put("userId", userId);
		this.put("userSeq", request.getSession(false).getAttribute("userSeq").toString());		
		this.put("path", request.getSession().getServletContext().getRealPath("\\"));		
		
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
		
		logger.debug("WhiteMap: "+this);
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
	
}


