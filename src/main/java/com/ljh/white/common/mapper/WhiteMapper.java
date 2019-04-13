package com.ljh.white.common.mapper;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;






@Repository("WhiteMapper")
public class WhiteMapper {
	
	private static final Logger logger = LoggerFactory.getLogger(WhiteMapper.class);
	
	@Autowired
	private SqlSession sqlSession;	
	
	public List<WhiteMap> selectNavAuthList() {
		logger.debug("");
		return sqlSession.selectList("whiteMapper.selectNavAuthList");
	}
	
	public List<WhiteMap> selectSideAuthList() {
		logger.debug("");
		return sqlSession.selectList("whiteMapper.selectSideAuthList");
	}
	
	/**
	 * 코드리스트 SELECT
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectCodeList(WhiteMap param) {
		logger.debug(param.toString());
		return sqlSession.selectList("whiteMapper.selectCodeList", param);
	}
	
	/**
	 * 테이블 순번 전체 조회
	 * @param tbNm
	 * @param colNm
	 * @return
	 */
	public List<WhiteMap> selectSortTable(WhiteMap param) {
		logger.debug(param.toString());
		return sqlSession.selectList("whiteMapper.selectSortTable", param);
	}
	
	/**
	 * 테이블 순번 자동 정렬 저장
	 * @param tbNm
	 * @param colNm
	 * @return
	 */
	public void updateSortTable(WhiteMap param) {
		sqlSession.update("whiteMapper.updateSortTable", param);
	}
}
