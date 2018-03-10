package com.ljh.white.common.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.constant.TableColumns;
import com.ljh.white.common.mapper.WhiteMapper;

@Service("WhiteService")
public class WhiteService{

	@Resource(name = "WhiteMapper")
	private WhiteMapper whiteMapper;
	
	/**
	 * 나중에 관련로직 삭제할 것
	 * 입력된 테이블, 컬럼, 데이터로 해당 데이터의 갯수를 구함
	 * @deprecated
	 * @param table, column, data	
	 * @return count
	 * @date 2017.10.24
	 */
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
	
	public List<WhiteMap> selectSideMenuList(WhiteMap param) {		
		return whiteMapper.selectSideMenuList(param);		
	}
}
