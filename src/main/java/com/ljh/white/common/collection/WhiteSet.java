package com.ljh.white.common.collection;

import java.util.HashSet;
import java.util.List;

public class WhiteSet extends HashSet<Object>{
	
	private static final long serialVersionUID = -8590287654144510733L;

	public WhiteSet(){
		super();
	}
	
	public WhiteSet(String[] strArr){
		for(int i=0; i<strArr.length; i++){
			this.add(strArr[i]);
		}		
	}
	
	public WhiteSet(List<Object> list){
		for(int i=0; i<list.size(); i++){
			this.add(list.get(i));		
		}		
	}
}
