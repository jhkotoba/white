package com.ljh.white.ledger.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.common.Constant;
import com.ljh.white.common.White;
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
	
	/**
	 * 해당 유저 은행 리스트 반영
	 * @param parma
	 * @return
	 */
	public int applybankList(WhiteMap param) {
		List<WhiteMap> bankList = param.convertListWhiteMap("bankList", true);
		
		List<WhiteMap> deleteList = new ArrayList<WhiteMap>();
		List<WhiteMap> insertList = new ArrayList<WhiteMap>();
		List<WhiteMap> updateList = new ArrayList<WhiteMap>();
		StringBuffer sb = new StringBuffer();
		
		for(int i=0; i<bankList.size(); i++) {
			sb.append(bankList.get(i).get("bankSeq")).append(",");
			
			if("delete".equals(bankList.get(i).get("state"))) {
				deleteList.add(bankList.get(i));
			}else if("insert".equals(bankList.get(i).get("state"))) {
				insertList.add(bankList.get(i));
			}else {
				updateList.add(bankList.get(i));
			}
		}
		
		sb.setLength(sb.length() - 1);
		param.put("verifyBankSeqList", sb.toString());		
		
		if(ledgerMapper.selectVerifyBankSeqStrList(param)>0) {
			return -1;
		}else if(deleteList.size()>0 && ledgerMapper.selectIsUsedBankRec(deleteList)>0) {				
			return -2;
		}else {
			if(deleteList.size()>0) ledgerMapper.deleteBankList(deleteList);
			if(insertList.size()>0) ledgerMapper.insertBankList(insertList);	
			if(updateList.size()>0) ledgerMapper.updateBankList(updateList);
			return 1;
		}
	}
	
	/**
	 * 금전기록List insert
	 * @param list
	 * @return 
	 * -1 : 날짜값이 정상적이지 않는 경우
	 * -2 : 위치값 길이 오버 (20자)
	 * -3 : 내용값 널값이거나 빈값
	 * -4 : 내용값 길이 오버 (50자)
	 * -5 : 사용수단 seq값 널값인 경우
	 * -6 : 목적 seq값 널인 경우
	 * -7 : 목적타입이 이동인 경우에서 받는곳이 널값인 경우
	 * -8 : 목적타입이 이동인 경우에서 보내는곳과 받는곳이 같은 경우
	 * -9 : 목적타입이 이동이 아닌 경우에서 받는곳의 값이 있는 경우
	 * -10 : 상세목적이 목적의 하위그룹에 속하지 않는 경우
	 * -11 : 금액값이 정상적이지 않는 경우
	 * 0:데이터없어서 insert실행 하지 않음
	 * 1 이상 : 정상(등록 개수)
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int insertRecordList(WhiteMap param) {		
		List<WhiteMap> list = param.convertListWhiteMap("insertList", true);		
		
		List<WhiteMap> purList = this.selectPurList(param);
		
		WhiteMap purSeqMap = White.convertListToMap(purList, "purSeq", "purpose");	
		WhiteMap purTypeMap = White.convertListToMap(purList, "purSeq", "purType");	
		WhiteMap purDtlSeqMap = White.convertListToMap(this.selectPurDtlList(param), "purDtlSeq", "purSeq");
		WhiteMap bankSeqMap = White.convertListToMap(this.selectBankList(param), "bankSeq", "bankName");
		bankSeqMap.put("0", "cash");
		
		String str = null;
		
		if(list.size() == 0) return 0;		
		for(int i=0; i<list.size(); i++) {			
			//날짜 검사
			str = list.get(i).getString("recordDate");
			if(!White.dateCheck(str, "yyyy-MM-dd HH:mm")) return -1;
			
			//위치 검사
			str = list.get(i).getString("position");			
			if(str.length() > Constant.POSITION_LENGTH)	return -2;
			
			//내용 검사
			str = list.get(i).getString("content");	
			if(str == null || "".equals(str)) return -3;
			else if(str.length() > Constant.CONTENT_LENGTH) return -4;
			
			//사용수단 검사
			str = list.get(i).getString("bankSeq");			
			if(bankSeqMap.get(str) == null) return -5;			
			
			//목적 검사
			str = list.get(i).getString("purSeq");			
			if(purSeqMap.get(str) == null) return -6;
			
			//목적타입이 이동인 경우 검사
			if("LP003".equals(purTypeMap.get(str))) {
				String moveSeq = list.get(i).getString("moveSeq");
				if(bankSeqMap.get(moveSeq) == null) return -7;				
				if(moveSeq.equals(list.get(i).getString("bankSeq"))) return -8;
			//목적타입이 이동이 아닌 경우 검사
			}else {				
				if(!"".equals(list.get(i).getString("moveSeq"))) return -9;
			}
			
			//상세목적 검사
			str = list.get(i).getString("purDtlSeq");			
			if(!"".equals(str)) {
				if(!list.get(i).getString("purSeq").equals(purDtlSeqMap.get(str))) return -10;
			}		
			
			//금액 검사
			str = list.get(i).getString("money");
			try {
				int money = Integer.parseInt(str);
				switch(purTypeMap.get(list.get(i).getString("purSeq")).toString()) {
				case "LP001":
					if(money <= 0) return -11; break;
				case "LP002":
				case "LP003":
					if(money >= 0) return -11; break;
				default:
					return -11;				
				}
				
			}catch (NumberFormatException e) {
				return -11;
			}
		}
		return ledgerMapper.insertRecordList(list);
	}
	
	/**
	 * 해당 유저 가계부 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectRecordList(WhiteMap param){
		return ledgerMapper.selectRecordList(param);
	}
	
	/**
	 * 해당 유저 가계부 조회(금액 합산)
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectRecordSumList(WhiteMap param){
		
		List<WhiteMap> bankList = this.selectBankList(param);
		//금전기록 기간 조회시 기간 이전  각각(현금, 은행등등) 금액 데이터 합산
		List<WhiteMap> pastRecList = new ArrayList<WhiteMap>();
		WhiteMap map = null;
		for(int i=0; i<bankList.size()+1; i++) {
			map = new WhiteMap();
			if(i==0) {
				map.put("bankName", "cash");
				map.put("bankSeq", 0);				
				map.put("userSeq", param.getInt("userSeq"));
				map.put("startDate", param.getString("startDate"));
			}else {
				map.put("bankName", "bank"+(i-1));
				map.put("bankSeq", bankList.get(i-1).getInt("bankSeq"));
				map.put("userSeq", param.getInt("userSeq"));
				map.put("startDate", param.getString("startDate"));
			}
			pastRecList.add(map);
		}		
		WhiteMap pastRec = ledgerMapper.selectCalPastRecord(pastRecList);
		
		//금전기록 조회
		List<WhiteMap> recList = ledgerMapper.selectRecordList(param);
		
		//총계 변수에 금액 증감
		int amount = 0;	
		
		//현금,은행별금액  금액증감
		int m = 0;
		WhiteMap moneyMap = new WhiteMap();
		m = pastRec == null ? 0 : pastRec.getInt("cash");
		moneyMap.put("0", m);
		amount += m;
		for(int i=0; i<bankList.size(); i++) {
			m = pastRec == null ? 0 : pastRec.getInt("bank"+i);
			moneyMap.put(bankList.get(i).getString("bankSeq"), m );			
			amount += m;
		}
		for(int i=0; i<recList.size(); i++) {			
			//현금이동일때는 금액증감 제외, purSeq가 0인값은 금액이동
			if("LP003".equals(recList.get(i).getString("purType"))) {
				recList.get(i).put("amount", amount);
			}else {
				amount += recList.get(i).getInt("money");
				recList.get(i).put("amount", amount);
			}
			//현금쪽 각 행마다 money 증감
			if("0".equals(recList.get(i).getString("bankSeq"))) {				
				int cash = moneyMap.getInt("0");
				cash += recList.get(i).getInt("money");
				moneyMap.put("0", cash);
			//각각은행 money 증감
			}else{				
				String bankSeq = recList.get(i).getString("bankSeq");
				int bankMoney = moneyMap.getInt(bankSeq);
				bankMoney += recList.get(i).getInt("money");
				moneyMap.put(bankSeq, bankMoney);				
			}			
			//현금이동시 받는쪽 추가
			if(!("".equals(recList.get(i).getString("moveSeq")) || recList.get(i).getString("moveSeq")==null)){				
				int addMoveMoney = moneyMap.getInt(recList.get(i).getString("moveSeq"));
				addMoveMoney += Math.abs(recList.get(i).getInt("money"));
				moneyMap.put(recList.get(i).getString("moveSeq"), addMoveMoney);
			}			
			//현금금액 증감 map추가
			recList.get(i).put("cash", moneyMap.getInt("0"));
			//은행별 추가 map추가
			recList.get(i).put("bankIdxLen", bankList.size()-1);
			for(int j=0; j<bankList.size(); j++) {
				recList.get(i).put(bankList.get(j).getString("bankAccount"), moneyMap.getInt(bankList.get(j).getString("bankSeq")));
				//recList.get(i).put("bank"+j, moneyMap.getInt(bankList.get(j).getString("bankSeq")));
			}						
		}		
		return recList;			
	}
	
	/**
	 * 금전기록 수정 및 삭제
	 * @param param
	 * @return
	 */
	public int applyRecordList(WhiteMap param) {
		
		
		
		
		
		return 0;
	}
}
