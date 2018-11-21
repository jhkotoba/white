package com.ljh.white.ledger.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.ledger.mapper.LedgerMapper;


@Service("LedgerService")
public class LedgerService {
	
	@Resource(name = "LedgerMapper")
	private LedgerMapper ledgerMapper;
	
	/**
	 * 해당유저 목적 리스트
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurList(WhiteMap param) {		
		return ledgerMapper.selectPurList(param);		
		
	}	
	/**
	 * 해당유저 상세목적 리스트
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurDtlList(WhiteMap param) {		
		return ledgerMapper.selectPurDtlList(param);
	}
	
	/**
	 * 목적리스트 반영
	 * @param param
	 * @return -1: 목적 시퀀스 불일치 -2:삭제대상이 상세목적에 사용되는 시퀀스. 삭제불가 -3:삭제대상이 거래내역에 사용되는 시퀀스. 삭제불가, 1:성공
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int applyPurList(WhiteMap param) {
		
		List<WhiteMap> purList = param.convertListWhiteMap("purList", true);
		
		List<WhiteMap> deleteList = new ArrayList<WhiteMap>();
		List<WhiteMap> insertList = new ArrayList<WhiteMap>();
		List<WhiteMap> updateList = new ArrayList<WhiteMap>();
		StringBuffer sb = new StringBuffer();
		
		for(int i=0; i<purList.size(); i++) {			
			sb.append(purList.get(i).get("purSeq")).append(",");
			
			if("delete".equals(purList.get(i).get("state"))) {
				deleteList.add(purList.get(i));
			}else if("insert".equals(purList.get(i).get("state"))) {
				insertList.add(purList.get(i));
			}else {
				updateList.add(purList.get(i));
			}
		}
		
		sb.setLength(sb.length() - 1);
		param.put("verifyPurSeqList", sb.toString());		
		
		if(ledgerMapper.selectVerifyPurSeqStrList(param)>0) {
			return -1;
		}else if(deleteList.size()>0 && ledgerMapper.selectIsUsedPurposePurDtl(deleteList)>0) {				
			return -2;
		}else if(deleteList.size()>0 && ledgerMapper.selectIsUsedPurposeRec(deleteList)>0) {				
			return -3;
		}else {
			if(deleteList.size()>0) ledgerMapper.deletePurList(deleteList);
			if(insertList.size()>0) ledgerMapper.insertPurList(insertList);	
			if(updateList.size()>0) ledgerMapper.updatePurList(updateList);
			return 1;
		}
	}
	
	
	/**
	 * 상세목적 리스트 반영
	 * @param param
	 * @return -1: 상세목적 시퀀스 불일치 -2:삭제대상이 거래내역에 사용되는 시퀀스. 삭제불가, 1:성공
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int applyPurDtlList(WhiteMap param) {
		
		List<WhiteMap> purDtlList = param.convertListWhiteMap("purDtlList", true);
		
		List<WhiteMap> deleteList = new ArrayList<WhiteMap>();
		List<WhiteMap> insertList = new ArrayList<WhiteMap>();
		List<WhiteMap> updateList = new ArrayList<WhiteMap>();
		StringBuffer sb = new StringBuffer();
		
		for(int i=0; i<purDtlList.size(); i++) {
			sb.append(purDtlList.get(i).get("purDtlSeq")).append(",");
			
			if("delete".equals(purDtlList.get(i).get("state"))) {
				deleteList.add(purDtlList.get(i));
			}else if("insert".equals(purDtlList.get(i).get("state"))) {
				insertList.add(purDtlList.get(i));
			}else {
				updateList.add(purDtlList.get(i));
			}
		}
		
		sb.setLength(sb.length() - 1);
		param.put("verifyPurDtlSeqList", sb.toString());		
		
		if(ledgerMapper.selectVerifyPurDtlSeqStrList(param)>0) {
			return -1;
		}else if(ledgerMapper.selectVerifyPurSeq(param)!=1) {
			return -1;
		}else if(deleteList.size()>0 && ledgerMapper.selectIsUsedPurDtlRec(deleteList)>0) {				
			return -2;
		}else {
			if(deleteList.size()>0) ledgerMapper.deletePurDtlList(deleteList);
			if(insertList.size()>0) ledgerMapper.insertPurDtlList(insertList);	
			if(updateList.size()>0) ledgerMapper.updatePurDtlList(updateList);
			return 1;
		}
	}
	
	/**
	 * 해당 유저 은행리스트
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectBankList(WhiteMap param){		
		return ledgerMapper.selectBankList(param);	
	}
}
