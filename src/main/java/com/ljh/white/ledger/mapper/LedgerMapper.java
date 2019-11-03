package com.ljh.white.ledger.mapper;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.extend.CommonMapper;

@Repository("LedgerMapper")
public class LedgerMapper extends CommonMapper{
	
	/**
	 * 해당 유저 목적 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurList(WhiteMap param) {
		return selectList("ledgerMapper.selectPurList", param);
	}
	
	/**
	 * 해당 유저 상세목적 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurDtlList(WhiteMap param) {
		return selectList("ledgerMapper.selectPurDtlList", param);
	}
	
	/**
	 * 해당 유저 목적 반영하기전 목적 시퀀스 검증
	 * @param list
	 * @return
	 */
	public int selectVerifyPurSeqStrList(WhiteMap param) {
		return selectInt("ledgerMapper.selectVerifyPurSeqStrList", param);
	}
	
	/**
	 * 거래내역에 목적이 사용되는지 확인
	 * @param list
	 * @return
	 */
	public int selectIsUsedPurposeRec(List<WhiteMap> list) {
		return selectInt("ledgerMapper.selectIsUsedPurposeRec", list);		 
	}
	
	/**
	 * 목적 삭제시 상세목적에 부모로써 사용되는지 확인 
	 * @param list
	 * @return
	 */
	public int selectIsUsedPurposePurDtl(List<WhiteMap> list) {		
		return selectInt("ledgerMapper.selectIsUsedPurposePurDtl", list);		 
	}	
	
	/**
	 * 목적 리스트 delete
	 * @param list
	 * @return
	 */
	public int deletePurList(List<WhiteMap> list) {		
		return delete("ledgerMapper.deletePurList", list);		 
	}
	
	/**
	 * 목적 리스트 insert
	 * @param list
	 * @return
	 */
	public int insertPurList(List<WhiteMap> list) {		
		return insert("ledgerMapper.insertPurList", list);		 
	}	
	
	/**
	 * 목적 리스트 update
	 * @param list
	 * @return
	 */
	public int updatePurList(List<WhiteMap> list) {		
		return update("ledgerMapper.updatePurList", list);		 
	}
	
	/**
	 * 해당 유저 상세목적 반영하기전 상세목적 시퀀스 검증
	 * @param list
	 * @return
	 */
	public int selectVerifyPurDtlSeqStrList(WhiteMap param) {
		return selectInt("ledgerMapper.selectVerifyPurDtlSeqStrList", param);
	}
	
	/**
	 * 해당유저 상세목적 반영하기전 목적 시퀀스 검증
	 * @param list
	 * @return 1: OK, 1이외숫자 NO
	 */
	public int selectVerifyPurSeq(WhiteMap param) {
		return selectInt("ledgerMapper.selectVerifyPurSeq", param);
	}
	
	
	/**
	 * 거래내역에 상세목적이 사용되는지 확인
	 * @param list
	 * @return
	 */
	public int selectIsUsedPurDtlRec(List<WhiteMap> list) {		
		return selectInt("ledgerMapper.selectIsUsedPurDtlRec", list);		 
	}
	
	/**
	 * 상세목적 리스트 delete
	 * @param list
	 * @return
	 */
	public int deletePurDtlList(List<WhiteMap> list) {		
		return delete("ledgerMapper.deletePurDtlList", list);		 
	}
	
	/**
	 * 상세목적 리스트 update
	 * @param list
	 * @return
	 */
	public int updatePurDtlList(List<WhiteMap> list) {		
		return update("ledgerMapper.updatePurDtlList", list);		 
	}
	
	/**
	 * 상세목적 리스트 insert
	 * @param list
	 * @return
	 */
	public int insertPurDtlList(List<WhiteMap> list) {		
		return insert("ledgerMapper.insertPurDtlList", list);		 
	}
	
	/**
	 * 해당 유저 은행 리스트 조회
	 * @param paramMap
	 * @return
	 */
	public List<WhiteMap> selectMeansList(WhiteMap param) {
		return selectList("ledgerMapper.selectMeansList", param);
	}
	
	/**
	 * 해당 유저 은행리스트 반영하기전 상세목적 시퀀스 검증
	 * @param list
	 * @return
	 */
	public int selectVerifyMeansSeqStrList(WhiteMap param) {
		return selectInt("ledgerMapper.selectVerifyMeansSeqStrList", param);
	}
	
	/**
	 * 은행 사용되는지 확인
	 * @param list
	 * @return
	 */
	public int selectIsUsedMeansRec(List<WhiteMap> list) {		
		return selectInt("ledgerMapper.selectIsUsedMeansRec", list);		 
	}
	
	/**
	 * 은행 List insert
	 * @param list
	 * @return
	 */
	public int insertMeansList(List<WhiteMap> list) {
		return insert("ledgerMapper.insertMeansList", list);
	}
	
	/**
	 * 은행 List update
	 * @param list
	 * @return
	 */
	public int updateMeansList(List<WhiteMap> list) {		
		return update("ledgerMapper.updateMeansList", list);		
	}
	
	/**
	 * 은행 List delete
	 * @param list
	 * @return
	 */
	public int deleteMeansList(List<WhiteMap> list) {		
		return delete("ledgerMapper.deleteMeansList", list);		 
	}
	
	/**
	 * 금전기록List insert
	 * @param list
	 * @return
	 */
	public int insertRecordList(List<WhiteMap> list) {
		return insert("ledgerMapper.insertRecordList", list);
	}
	
	/**
	 * 금전기록 해당날짜 이전 각각(현금, 은행등등) 금액 합산 조회
	 * @param pastRec
	 * @return
	 */
	public WhiteMap selectPastCalLedger(List<WhiteMap> list) {
		return selectOne("ledgerMapper.selectPastCalLedger", list);
	}	
	/** @deprecated 새로작성중
	 * 금전기록 해당날짜 이전 각각(현금, 은행등등) 금액 합산 조회 old
	 * @param pastRec
	 * @return
	 */
	public WhiteMap selectPastCalLedgerOLD(List<WhiteMap> list) {
		return selectOne("ledgerMapper.selectPastCalLedgerOLD", list);
	}	
	
	
	
	/** @deprecated 새로작성중
	 * 해당 유저 가계부 조회
	 * @param list
	 * @return
	 */
	public List<WhiteMap> selectRecordList(WhiteMap param) {		
		return selectList("ledgerMapper.selectRecordList", param);		 
	}
	/**
	 * 해당 유저 가계부 조회
	 * @param list
	 * @return
	 */
	public List<WhiteMap> selectLedgerList(WhiteMap param) {		
		return selectList("ledgerMapper.selectLedgerList", param);		 
	}
	
	/**
	 * 금전기록 update
	 * @param list
	 * @return
	 */
	public int updateRecordList(List<WhiteMap> list) {
		return update("ledgerMapper.updateRecordList", list);
	}
	
	/**
	 * 금전기록 delete
	 * @param list
	 * @return
	 */
	public int deleteRecordList(List<WhiteMap> list) {
		return delete("ledgerMapper.deleteRecordList", list);
	}	
	
	/**
	 * 가계부 첫 입력 날짜 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectFirstRecordDate(WhiteMap param) {
		return selectOne("ledgerMapper.selectFirstRecordDate", param);
	}
	
	/**
	 * 가계부 통계 월별 수입지출 이전 합계
	 * @param param
	 * @return
	 */
	public int selectPrevAmount(WhiteMap param) {
		return selectInt("ledgerMapper.selectPrevAmount", param);
	}
	
	/**
	 * 가계부 통계 월별 수입지출
	 * @param list
	 * @return
	 */
	public List<WhiteMap> selectLedgerMonthIEStats(List<WhiteMap> list) {
		return selectList("ledgerMapper.selectLedgerMonthIEStats", list);
	}
	
	/**
	 * 가계부 통계 월 목적별 수입지출
	 * @param list
	 * @return
	 */
	public List<WhiteMap> selectLedgerMonthPurStats(WhiteMap param) {
		return selectList("ledgerMapper.selectLedgerMonthPurStats", param);
	}
	
	/**
	 * 가계부 통계 월 상세목적별 수입지출
	 * @param list
	 * @return
	 */
	public List<WhiteMap> selectLedgerMonthPurDtlStats(WhiteMap param) {
		return selectList("ledgerMapper.selectLedgerMonthPurDtlStats", param);
	}
	
	
}
