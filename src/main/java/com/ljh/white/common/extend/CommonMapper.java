package com.ljh.white.common.extend;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.interfere.Constant;
import com.ljh.white.common.util.CommonStringUtils;

public class CommonMapper {
	
	@Autowired
	private SqlSession sqlSession;
	
	public int selectInt(String statement, Object parameter){
		return sqlSession.selectOne(statement, parameter);
	}
	
	public WhiteMap selectOne(String statement, Object parameter, boolean isCamelCase){
		if(isCamelCase) {
			return this.selectOne(statement, parameter);
		}else {
			return sqlSession.selectOne(statement, parameter);
		}
	}	
	
	public WhiteMap selectOne(String statement, Object parameter){	
		return this.converterCamelCase((WhiteMap)sqlSession.selectOne(statement, parameter));
	}
	
	public List<WhiteMap> selectList(String statement, Object parameter, boolean isCamelCase){
		if(isCamelCase) {
			return this.selectList(statement, parameter);
		}else {
			return sqlSession.selectList(statement, parameter);
		}
	}
	
	public List<WhiteMap> selectList(String statement, Object parameter){
		List<WhiteMap> list = sqlSession.selectList(statement, parameter);
		return this.converterCamelCase(list);
	}
	
	public int insert(String statement) {
		return sqlSession.insert(statement, null);
	}
	
	public int insert(String statement, Object parameter) {
		return sqlSession.insert(statement, parameter);
	}
	
	public int update(String statement) {
		return sqlSession.update(statement, null);
	}
	
	public int update(String statement, Object parameter) {
		return sqlSession.update(statement, parameter);
	}
	
	public int delete(String statement) {
		return sqlSession.delete(statement, null);
	}
	
	public int delete(String statement, Object parameter) {
		return sqlSession.delete(statement, parameter);
	}
	
	
	private List<WhiteMap> converterCamelCase(List<WhiteMap> list){
		if(list.size() > 0) {
			
			Set<String> set = list.get(0).keySet();
			HashMap<String, String> keyMap = new HashMap<String, String>();			
			set.forEach(key -> {
				keyMap.put(key, this.converterCamelCaseString(key));
			});			
			
			List<WhiteMap> resultList = new ArrayList<WhiteMap>();		
			list.forEach(item -> {
				
				WhiteMap param = new WhiteMap();
				Iterator<String> ite = item.keySet().iterator();
				
				while(ite.hasNext()) {				
					String key = ite.next();
					param.put(keyMap.get(key), item.get(key));
				}
				
				resultList.add(param);
			});
			
			return resultList;
			
		}else {
			return list;
		}		
	}
	
	private WhiteMap converterCamelCase(WhiteMap param){
		if(param == null || param.isEmpty()) {
			return param;
		}else {			
			WhiteMap result = new WhiteMap();
			Iterator<String> ite = param.keySet().iterator();
			
			while(ite.hasNext()) {				
				String key = ite.next();
				result.put(this.converterCamelCaseString(key), param.get(key));
			}			
			return result;
		}
	}
	
	private String converterCamelCaseString(String key) {
		StringBuilder sBuilder = new StringBuilder();
		String[] splitKey = key.split("_");
		if(splitKey.length < 2){			
			if(CommonStringUtils.isAllUpper(splitKey[0])) {
				return splitKey[0].toLowerCase();
			}else {
				return splitKey[0];
			}
		}else {
			for(int i=0; i<splitKey.length; i++) {
				if(i == 0) {
					sBuilder.append(splitKey[i].toLowerCase());
				}else {
					sBuilder.append(splitKey[i].substring(0,1).toUpperCase() + splitKey[i].substring(1).toLowerCase());
				}
			}
		}		
		return sBuilder.toString();
	}
}
