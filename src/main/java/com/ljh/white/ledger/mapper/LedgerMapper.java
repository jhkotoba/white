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
	
	/**
	 * 해당 유저 목적 반영하기전 목적 시퀀스 검증
	 * @param list
	 * @return
	 */
	public int selectVerifyPurSeqStrList(WhiteMap param) {
		return sqlSession.selectOne("ledgerMapper.selectVerifyPurSeqStrList", param);
	}
	
	/**
	 * 거래내역에 목적이 사용되는지 확인
	 * @param list
	 * @return
	 */
	public int selectIsUsedPurposeRec(List<WhiteMap> list) {
		return sqlSession.selectOne("ledgerMapper.selectIsUsedPurposeRec", list);		 
	}
	
	/**
	 * 목적 삭제시 상세목적에 부모로써 사용되는지 확인 
	 * @param list
	 * @return
	 */
	public int selectIsUsedPurposePurDtl(List<WhiteMap> list) {		
		return sqlSession.selectOne("ledgerMapper.selectIsUsedPurposePurDtl", list);		 
	}	
	
	/**
	 * 목적 리스트 delete
	 * @param list
	 * @return
	 */
	public int deletePurList(List<WhiteMap> list) {		
		return sqlSession.delete("ledgerMapper.deletePurList", list);		 
	}
	
	/**
	 * 목적 리스트 insert
	 * @param list
	 * @return
	 */
	public int insertPurList(List<WhiteMap> list) {		
		return sqlSession.insert("ledgerMapper.insertPurList", list);		 
	}	
	
	/**
	 * 목적 리스트 update
	 * @param list
	 * @return
	 */
	public int updatePurList(List<WhiteMap> list) {		
		return sqlSession.update("ledgerMapper.updatePurList", list);		 
	}
	
	/**
	 * 해당 유저 상세목적 반영하기전 상세목적 시퀀스 검증
	 * @param list
	 * @return
	 */
	public int selectVerifyPurDtlSeqStrList(WhiteMap param) {
		return sqlSession.selectOne("ledgerMapper.selectVerifyPurDtlSeqStrList", param);
	}
	
	/**
	 * 해당유저 상세목적 반영하기전 목적 시퀀스 검증
	 * @param list
	 * @return 1: OK, 1이외숫자 NO
	 */
	public int selectVerifyPurSeq(WhiteMap param) {
		return sqlSession.selectOne("ledgerMapper.selectVerifyPurSeq", param);
	}
	
	
	/**
	 * 거래내역에 상세목적이 사용되는지 확인
	 * @param list
	 * @return
	 */
	public int selectIsUsedPurDtlRec(List<WhiteMap> list) {		
		return sqlSession.selectOne("ledgerMapper.selectIsUsedPurDtlRec", list);		 
	}
	
	/**
	 * 상세목적 리스트 delete
	 * @param list
	 * @return
	 */
	public int deletePurDtlList(List<WhiteMap> list) {		
		return sqlSession.delete("ledgerMapper.deletePurDtlList", list);		 
	}
	
	/**
	 * 상세목적 리스트 update
	 * @param list
	 * @return
	 */
	public int updatePurDtlList(List<WhiteMap> list) {		
		return sqlSession.update("ledgerMapper.updatePurDtlList", list);		 
	}
	
	/**
	 * 상세목적 리스트 insert
	 * @param list
	 * @return
	 */
	public int insertPurDtlList(List<WhiteMap> list) {		
		return sqlSession.insert("ledgerMapper.insertPurDtlList", list);		 
	}
	
	/**
	 * 해당 유저 은행 리스트 조회
	 * @param paramMap
	 * @return
	 */
	public List<WhiteMap> selectBankList(WhiteMap param) {
		return sqlSession.selectList("ledgerMapper.selectBankList", param);
	}
	
	/**
	 * 해당 유저 은행리스트 반영하기전 상세목적 시퀀스 검증
	 * @param list
	 * @return
	 */
	public int selectVerifyBankSeqStrList(WhiteMap param) {
		return sqlSession.selectOne("ledgerMapper.selectVerifyBankSeqStrList", param);
	}
	
	/**
	 * 은행 사용되는지 확인
	 * @param list
	 * @return
	 */
	public int selectIsUsedBankRec(List<WhiteMap> list) {		
		return sqlSession.selectOne("ledgerMapper.selectIsUsedBankRec", list);		 
	}
	
	/**
	 * 은행 List insert
	 * @param list
	 * @return
	 */
	public int insertBankList(List<WhiteMap> list) {
		return sqlSession.insert("ledgerMapper.insertBankList", list);
	}
	
	/**
	 * 은행 List update
	 * @param list
	 * @return
	 */
	public int updateBankList(List<WhiteMap> list) {		
		return sqlSession.update("ledgerMapper.updateBankList", list);		
	}
	
	/**
	 * 은행 List delete
	 * @param list
	 * @return
	 */
	public int deleteBankList(List<WhiteMap> list) {		
		return sqlSession.delete("ledgerMapper.deleteBankList", list);		 
	}	
	
}
