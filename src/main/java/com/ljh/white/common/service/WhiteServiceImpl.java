package com.ljh.white.common.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.constant.TableColumns;
import com.ljh.white.common.mapper.WhiteMapper;

@Service("WhiteService")
public class WhiteServiceImpl implements WhiteService{

	@Resource(name = "WhiteMapper")
	private WhiteMapper whiteMapper;
	
	//입력된 테이블, 컬럼, 데이터로 해당 데이터의 갯수를 구함
	@Override
	public int isCntColumn(String table, String column, String data) {		
		//테이블 컬럼 존재 체크
		if(!TableColumns.getTableSet().contains(table.toLowerCase()))	
			return -1;
		else if(!TableColumns.isTableSet(table).contains(column.toLowerCase())){
			return -1;
		}
		
		WhiteMap whiteMap = new WhiteMap();
		whiteMap.put("table", table);
		whiteMap.put("column", column);
		whiteMap.put("data", data);
		
		return whiteMapper.selectIsCntColumn(whiteMap);
		
	}
}
