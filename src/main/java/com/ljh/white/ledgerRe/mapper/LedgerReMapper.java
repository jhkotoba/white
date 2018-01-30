package com.ljh.white.ledgerRe.mapper;

import java.util.List;

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
	public List<WhiteMap> selectBankList(WhiteMap param) {
		return sqlSession.selectList("ledgerReMapper.selectBankList", param);
	}
	
	public List<WhiteMap> selectPurList(WhiteMap param) {
		return sqlSession.selectList("ledgerReMapper.selectPurList", param);
	}
	
	public List<WhiteMap> selectPurDtlList(WhiteMap param) {
		return sqlSession.selectList("ledgerReMapper.selectPurDtlList", param);
	}
	
	/**
	 * 해당 유저 금전기록 리스트 조회
	 * @param paramMap
	 * @return
	 */
	public List<WhiteMap> selectRecordList(WhiteMap param) {
		return sqlSession.selectList("ledgerReMapper.selectRecordList", param);
	}
	
	/**
	 * 금전기록 해당날짜 이전 각각 금액 합산 조회
	 * @param pastRec
	 * @return
	 */
	public WhiteMap selectCalPastRecord(List<WhiteMap> list) {
		return sqlSession.selectOne("ledgerReMapper.selectCalPastRecord", list);
	}
	
	/**
	 * 금전기록List insert
	 * @param list
	 * @return
	 */
	public int insertRecordList(List<WhiteMap> list) {
		return sqlSession.insert("ledgerReMapper.insertRecordList", list);
	}
}
