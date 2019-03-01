package com.ljh.white._old.ledgerRe;

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
	
	/**
	 * 해당 유저 목적 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurList(WhiteMap param) {
		return sqlSession.selectList("ledgerReMapper.selectPurList", param);
	}
	
	/**
	 * 해당 유저 상세목적 리스트 조회
	 * @param param
	 * @return
	 */
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
	 * 금전기록 해당날짜 이전 각각(현금, 은행등등) 금액 합산 조회
	 * @param pastRec
	 * @return
	 */
	public WhiteMap selectCalPastRecord(List<WhiteMap> list) {
		return sqlSession.selectOne("ledgerReMapper.selectCalPastRecord", list);
	}
	
	/**
	 * 금전기록 해당날짜 이전 금액(통합) 합산 조회
	 * @param AmountMon
	 * @return
	 */
	public int selectCalPastAmountRecord(WhiteMap param) {
		return sqlSession.selectOne("ledgerReMapper.selectCalPastAmountRecord", param);
	}
	
	/**
	 * 금전기록List insert
	 * @param list
	 * @return
	 */
	public int insertRecordList(List<WhiteMap> list) {
		return sqlSession.insert("ledgerReMapper.insertRecordList", list);
	}
	
	/**
	 * 금전기록List update
	 * @param list
	 * @return
	 */
	public int updateRecordList(List<WhiteMap> list) {		
		return sqlSession.update("ledgerReMapper.updateRecordList", list);		
	}
	
	/**
	 * 금전기록List delete
	 * @param list
	 * @return
	 */
	public int deleteRecordList(List<WhiteMap> list) {		
		return sqlSession.delete("ledgerReMapper.deleteRecordList", list);		 
	}
	
	/**
	 * 목적 리스트 insert
	 * @param list
	 * @return
	 */
	public int insertPurList(List<WhiteMap> list) {		
		return sqlSession.insert("ledgerReMapper.insertPurList", list);		 
	}
	
	/**
	 * 상세목적 리스트 insert
	 * @param list
	 * @return
	 */
	public int insertPurDtlList(List<WhiteMap> list) {		
		return sqlSession.insert("ledgerReMapper.insertPurDtlList", list);		 
	}
	
	/**
	 * 목적 리스트 update
	 * @param list
	 * @return
	 */
	public int updatePurList(List<WhiteMap> list) {		
		return sqlSession.update("ledgerReMapper.updatePurList", list);		 
	}
	
	/**
	 * 상세목적 리스트 update
	 * @param list
	 * @return
	 */
	public int updatePurDtlList(List<WhiteMap> list) {		
		return sqlSession.update("ledgerReMapper.updatePurDtlList", list);		 
	}
	
	/**
	 * 목적 리스트 delete
	 * @param list
	 * @return
	 */
	public int deletePurList(List<WhiteMap> list) {		
		return sqlSession.delete("ledgerReMapper.deletePurList", list);		 
	}
	
	/**
	 * 상세목적 리스트 delete
	 * @param list
	 * @return
	 */
	public int deletePurDtlList(List<WhiteMap> list) {		
		return sqlSession.delete("ledgerReMapper.deletePurDtlList", list);		 
	}
	
	/**
	 * 목적 사용되는지 확인
	 * @param list
	 * @return
	 */
	public int selectIsUsedPurposeRec(List<WhiteMap> list) {		
		return sqlSession.selectOne("ledgerReMapper.selectIsUsedPurposeRec", list);		 
	}
	
	/**
	 * 목적 삭제시 상세목적에 부모로써 사용되는지 확인 
	 * @param list
	 * @return
	 */
	public int selectIsUsedPurposePurDtl(List<WhiteMap> list) {		
		return sqlSession.selectOne("ledgerReMapper.selectIsUsedPurposePurDtl", list);		 
	}
	
	/**
	 * 상세목적 사용되는지 확인
	 * @param list
	 * @return
	 */
	public int selectIsUsedPurDtl(List<WhiteMap> list) {		
		return sqlSession.selectOne("ledgerReMapper.selectIsUsedPurDtl", list);		 
	}
	
	
	/**
	 * 은행 List insert
	 * @param list
	 * @return
	 */
	public int insertBankList(List<WhiteMap> list) {
		return sqlSession.insert("ledgerReMapper.insertBankList", list);
	}
	
	/**
	 * 은행 List update
	 * @param list
	 * @return
	 */
	public int updateBankList(List<WhiteMap> list) {		
		return sqlSession.update("ledgerReMapper.updateBankList", list);		
	}
	
	/**
	 * 은행 List delete
	 * @param list
	 * @return
	 */
	public int deleteBankList(List<WhiteMap> list) {		
		return sqlSession.delete("ledgerReMapper.deleteBankList", list);		 
	}	
	
	/**
	 * 은행 사용되는지 확인
	 * @param list
	 * @return
	 */
	public int selectIsUsedBank(List<WhiteMap> list) {		
		return sqlSession.selectOne("ledgerReMapper.selectIsUsedBank", list);		 
	}
	
	/**
	 * 가계부 월별 통계 조회(수익, 지출, 누적)
	 * @param list
	 * @return
	 */
	public List<WhiteMap> selectMonthIEAStats(List<WhiteMap> list) {		
		return sqlSession.selectList("ledgerReMapper.selectMonthIEAStats", list);		 
	}
	
	/**
	 * 가계부 월별 통계 조회(현금, 은행별)
	 * @param list
	 * @return
	 */
	public List<WhiteMap> selectMonthCBStats(WhiteMap listMap) {		
		return sqlSession.selectList("ledgerReMapper.selectMonthCBStats", listMap);		 
	}
	
	/**
	 * 가계부 월별 통계 조회(목적별)
	 * @param list
	 * @return
	 */
	public List<WhiteMap> selectMonthPStats(WhiteMap listMap) {		
		return sqlSession.selectList("ledgerReMapper.selectMonthPStats", listMap);		 
	}
	
	
}
