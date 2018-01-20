package com.ljh.white.ledgerRe.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;

@Repository("LedgerReMapper")
public class LedgerReMapper {

	@Autowired
	private SqlSession sqlSession;
	
	/**
	 * 해당 유저 은행 리스트 조회
	 * @param paramMap
	 * @return
	 */
	public List<WhiteMap> selectBankList(Map<String, Object> paramMap) {
		return sqlSession.selectList("ledgerReMapper.selectBankList", paramMap);
	}
	
	/**
	 * 해당 유저 금전기록 리스트 조회
	 * @param paramMap
	 * @return
	 */
	public List<WhiteMap> selectRecordList(Map<String, Object> paramMap) {
		return sqlSession.selectList("ledgerReMapper.selectRecordList", paramMap);
	}
}
