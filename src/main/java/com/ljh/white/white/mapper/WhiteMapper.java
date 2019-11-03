package com.ljh.white.white.mapper;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.extend.CommonMapper;


@Repository("WhiteMapper")
public class WhiteMapper extends CommonMapper {
		
	public List<WhiteMap> selectUpperAuthList() {	
		return selectList("whiteMapper.selectUpperAuthList");
	}
	
	public List<WhiteMap> selectLowerAuthList() {	
		return selectList("whiteMapper.selectLowerAuthList");
	}
	
	/**
	 * 코드리스트 SELECT
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectCodeList(WhiteMap param) {	
		return selectList("whiteMapper.selectCodeList", param);
	}
	
	/**
	 * 테이블 순번 전체 조회
	 * @param tbNm
	 * @param colNm
	 * @return
	 */
	public List<WhiteMap> selectSortTable(WhiteMap param) {	
		return selectList("whiteMapper.selectSortTable", param);
	}
	
	/**
	 * 테이블 순번 자동 정렬 저장
	 * @param tbNm
	 * @param colNm
	 * @return
	 */
	public void updateSortTable(WhiteMap param) {
		update("whiteMapper.updateSortTable", param);
	}
}
