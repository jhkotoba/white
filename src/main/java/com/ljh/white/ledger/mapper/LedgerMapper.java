package com.ljh.white.ledger.mapper;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.ledger.bean.MoneyRecordBean;
import com.ljh.white.ledger.bean.PurposeBean;
import com.ljh.white.ledger.bean.PurposeDetailBean;
import com.ljh.white.ledger.bean.BankBean;
import java.io.Serializable;
/**  리뉴얼로 대체
 * @author lee
 * @deprecated
 */
@Repository("LedgerMapper")
public class LedgerMapper {
	
	private static Logger logger = LogManager.getLogger(LedgerMapper.class);

	@Autowired
	private SqlSession sqlSession;
	
	// 해당 시간 내역 조회 (Map< String 유저 시퀀스, String 시작날짜, String 종료날짜 >)
	public List<Map<String, Object>> getMoneyRecord(Map<String, Object> map ){		
		return sqlSession.selectList("ledgerMapper.getMoneyRecord", map);
	}
	
	// 조회 메인화면 최근 100건 조회  (Map<String 유저 시퀀스, String 시작날짜, String 종료날짜>)
	public List<Map<String, Object>> getLatestMoneyRecord(String userSeq){		
		return sqlSession.selectList("ledgerMapper.getLatestMoneyRecord", userSeq);
	}
	
	/** 해당유저 money_record 테이블 내역 전부 조회 (백업용) */
	public List<MoneyRecordBean> selectAllMoneyRecord(String userSeq){		
		return sqlSession.selectList("ledgerMapper.selectAllMoneyRecord", userSeq);
	}
	
	// 해당 시간 마지막 행 조회 (Map< String 유저 시퀀스, String 시작날짜, String 종료날짜 >)
	public Map<String, Object> serachLastRow(Map<String, String> map){		
		return sqlSession.selectOne("ledgerMapper.serachLastRow", map);
	}
	
/*	*//** 해당 유저의 purpose 테이블의 전체 목록을 조회  *//*
	public List<WhiteMap> getPurposeList(String userSeq){		
		return sqlSession.selectList("ledgerMapper.getPurposeList", userSeq);
	}
	
	// 해당 유저 은행List 조회 (String 유저 시퀀스)
	public List<WhiteMap> getBankList(String userSeq){
		return sqlSession.selectList("ledgerMapper.getBankList", userSeq);
	}*/
	
	/** 해당 유저의 purpose 테이블의 전체 목록을 조회  Bean */
	public List<PurposeBean> getPurposeList(String userSeq){		
		return sqlSession.selectList("ledgerMapper.getPurposeList", userSeq);
	}
	public List<PurposeDetailBean> getPurposeDtlList(String userSeq){		
		return sqlSession.selectList("ledgerMapper.getPurposeDtlList", userSeq);
	}
	
	public List<PurposeBean> getPurposeList_backup(String userSeq){		
		return sqlSession.selectList("ledgerMapper.getPurposeList_backup", userSeq);
	}
	
	/** 해당 유저 은행List 조회 (String 유저 시퀀스) Bean */
	public List<BankBean> getBankList(String userSeq){
		return sqlSession.selectList("ledgerMapper.getBankList", userSeq);
	}
	
	// 해당 유저 현재 사용하는 은행 List
	public List<Map<String, Object>> getUseBankList(String userSeq){		
		return sqlSession.selectList("ledgerMapper.getUseBankList", userSeq);
		
	}
	
	// money_record 테이블 해당 유정 총 카운트
	public int getRecordTotalCount(String userSeq){
		return sqlSession.selectOne("ledgerMapper.selectRecordTotalCount", userSeq);
	}
	
	//입력 정보 insert	
	public int setInsertRecode(List<Map<String, Object>> list) throws ParseException{		
		
		int insertCnt = 0;
		int updateCnt = 0;
		java.text.SimpleDateFormat sdformat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		Calendar cal = Calendar.getInstance();
		
		for(int i=0; i<list.size(); i++){				
			insertCnt += sqlSession.insert("ledgerMapper.setInsertRecode", list.get(i));
			int recordSeq = Integer.parseInt(list.get(i).get("recordSeq").toString());			
			updateCnt += sqlSession.update("ledgerMapper.updateNextModify", list.get(i));			
			
			//purSeq 가 0이면 현금이동
			if(list.get(i).get("purSeq").toString().equals("0")){
				
				list.get(i).put("bankSeq", list.get(i).get("moveToSeq"));
				list.get(i).put("moveToSeq", 0);
				list.get(i).put("groupSeq", recordSeq);
				list.get(i).put("inExpMoney", Math.abs(Integer.parseInt(list.get(i).get("inExpMoney").toString())));
				insertCnt += sqlSession.insert("ledgerMapper.setInsertRecode", list.get(i));				
				updateCnt += sqlSession.update("ledgerMapper.updateNextModify", list.get(i));
			}			
		}
		logger.debug("setInsertRecode insertCnt: " + insertCnt);
		logger.debug("setInsertRecode updateCnt: " + updateCnt);
		return insertCnt;
	}	
	
	//데이터 수정	
	public int updateRecode(List<Map<String, Object>> list){
		
		int updateCnt = 0;
		for(int i=0; i<list.size(); i++){
			updateCnt += sqlSession.update("ledgerMapper.editUpdateRecode", list.get(i));;	
		}
		logger.debug("updateRecode updateCnt: " + updateCnt);
		return updateCnt;
	}
	
	//데이터 삭제	
	public int deleteRecode(List<Map<String, Object>> list){
		
		int deleteCnt = 0;
		int updateCnt = 0;		
		for(int i=0; i<list.size(); i++){
			//System.out.println("list: "+ list.get(i));			
			updateCnt += sqlSession.update("ledgerMapper.updateNextModify", list.get(i));
			deleteCnt += sqlSession.delete("ledgerMapper.deleteRecode", list.get(i));;	
		}
		logger.debug("deleteRecode updateCnt: " + updateCnt);
		logger.debug("deleteRecode deleteCnt: " + deleteCnt);
		return deleteCnt;
	}
	
	//purpose insert	
	public int insertPurpose(List<Map<String, Object>> list){	
		return sqlSession.insert("ledgerMapper.insertPurpose", list);	
	}
	
	//purpose updete	
	public int updetePurpose(List<Map<String, Object>> list){	
		int updateCnt = 0;	
		for(int i=0; i<list.size(); i++){
			updateCnt += sqlSession.update("ledgerMapper.updatePurpose", list.get(i));
		}
		logger.debug("updetePurpose updateCnt: " + updateCnt);		
		return updateCnt;
	}
	
	//bank delete	
	public int deletePurpose(List<Map<String, Object>> list){
		
		
		int deleteCnt = sqlSession.delete("ledgerMapper.deletePurpose", list);
		logger.debug("deletePurpose deleteCnt: " + deleteCnt);
		
		//목적 삭제시 recode에 기록된 삭제된 목적 -1(기타)로 변경
		
		int delUpdateCnt = 0;
		for(int i=0; i<list.size(); i++){
			delUpdateCnt += sqlSession.update("ledgerMapper.updateRecordPurEdit", list.get(i));
		}
		logger.debug("updetePurpose updateCnt: " + delUpdateCnt);			
		
		return deleteCnt;
		
		
	}
	
	//purpose insert	
	public int insertDtlPurpose(List<Map<String, Object>> list){	
		return sqlSession.insert("ledgerMapper.insertDtlPurpose", list);	
	}
	
	//purpose updete	
	public int updeteDtlPurpose(List<Map<String, Object>> list){	
		int updateCnt = 0;	
		for(int i=0; i<list.size(); i++){
			updateCnt += sqlSession.update("ledgerMapper.updateDtlPurpose", list.get(i));
		}
		logger.debug("updeteDtlPurpose updateCnt: " + updateCnt);		
		return updateCnt;
	}
	
	//bank delete	
	public int deleteDtlPurpose(List<Map<String, Object>> list){
		
		
		int deleteCnt = sqlSession.delete("ledgerMapper.deleteDtlPurpose", list);
		logger.debug("deleteDtlPurpose deleteCnt: " + deleteCnt);
		
		//목적 삭제시 recode에 기록된 삭제된 목적 -1(기타)로 변경
		
		int delUpdateCnt = 0;
		for(int i=0; i<list.size(); i++){
			delUpdateCnt += sqlSession.update("ledgerMapper.updateRecordDtlPurEdit", list.get(i));
		}
		logger.debug("updeteDtlPurpose updateCnt: " + delUpdateCnt);			
		
		return deleteCnt;
		
		
	}
	
	
	//bank insert	
	public int insertBank(List<Map<String, Object>> list){	
		return sqlSession.insert("ledgerMapper.insertBank", list);	
	}		
		
	//bank update	
	public int updateBank(List<Map<String, Object>> list){	
		int updateCnt = 0;	
		for(int i=0; i<list.size(); i++){
			updateCnt += sqlSession.update("ledgerMapper.updateBank", list.get(i));
		}
		logger.debug("updetePurpose updateCnt: " + updateCnt);
		return updateCnt;
	}
	
	//bank delete	
	public int deleteBank(List<Map<String, Object>> list){
		//return sqlSession.update("ledgerMapper.deleteBank", list);
		logger.debug("deleteBank: " + list);
		int updateCnt = 0;	
		for(int i=0; i<list.size(); i++){
			updateCnt += sqlSession.update("ledgerMapper.deleteBank", list.get(i));
		}
		logger.debug("deleteBank updateCnt: " + updateCnt);
		
		return updateCnt;
	}
	
	
	//purpose, userBank, moneyRocord init delete
	public int deleteForInit(int userSeq){
		int cnt, sum = 0;
		sum += cnt = sqlSession.delete("ledgerMapper.deleteForInitPurpose", userSeq);
		logger.debug("purpose delete cnt: " + cnt);
		sum += cnt = sqlSession.delete("ledgerMapper.deleteForInitUserBank", userSeq);
		logger.debug("userBank delete cnt: " + cnt);
		sum += cnt = sqlSession.delete("ledgerMapper.deleteForInitRecord", userSeq);
		logger.debug("record delete cnt: " + cnt);
		return sum;
	}
	
	//purpose, userBank, moneyRocord init insert
	public List<Integer> insertBackupPurList(List<PurposeBean> purposeList, int userSeq){
		
		List<Integer> purNewSeqList = new ArrayList<Integer>();
		
		for(int i=0; i<purposeList.size(); i++){			
			purposeList.get(i).setUserSeq(userSeq);
			sqlSession.insert("ledgerMapper.insertBackupPurList", purposeList.get(i));
			purNewSeqList.add(purposeList.get(i).getPurSeq());
		}		
		return purNewSeqList;
	}
	
	//purpose, userBank, moneyRocord init insert
	public List<Integer> insertBackupBankList(List<BankBean> bankList, int userSeq){
		
		List<Integer> bankNewSeqList = new ArrayList<Integer>();
		
		for(int i=0; i<bankList.size(); i++){			
			bankList.get(i).setUserSeq(userSeq);
			sqlSession.insert("ledgerMapper.insertBackupBankList", bankList.get(i));
			bankNewSeqList.add(bankList.get(i).getBankSeq());
		}		
		return bankNewSeqList;
	}
	
	public int insertBackupRecord(List<MoneyRecordBean> recordList){
		
		return sqlSession.insert("ledgerMapper.insertBackupRecord",recordList);
	}
	
	
	
}
	
