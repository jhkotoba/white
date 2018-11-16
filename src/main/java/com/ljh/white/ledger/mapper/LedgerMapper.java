package com.ljh.white.ledger.mapper;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;

@Repository("LedgerMapper")
public class LedgerMapper {

	@Autowired
	private SqlSession sqlSession;
	
	/**
	 * 해당 유저 목적 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurList(WhiteMap param) {
		return sqlSession.selectList("ledgerMapper.selectPurList", param);
	}
	
	/**
	 * 해당 유저 상세목적 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurDtlList(WhiteMap param) {
		return sqlSession.selectList("ledgerMapper.selectPurDtlList", param);
	}
}
