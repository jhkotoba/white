package com.ljh.white.ledger.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.common.Constant;
import com.ljh.white.common.White;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.service.WhiteService;
import com.ljh.white.ledger.mapper.LedgerMapper;


@Service("LedgerService")
public class LedgerService {
	
	@Resource(name = "LedgerMapper")
	private LedgerMapper ledgerMapper;
	
	@Resource(name = "WhiteService")
	private WhiteService whiteService;
	
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
			if(insertList.size()>0) ledgerMapper.insertPurList(insertList);	
			if(updateList.size()>0) ledgerMapper.updatePurList(updateList);
			if(deleteList.size()>0) {
				ledgerMapper.deletePurList(deleteList);
				
				WhiteMap map = new WhiteMap();
				map.put("tableNm", "purpose");
				map.put("firstSeqNm", "pur_seq");				
				map.put("columnNm", "pur_order");
				map.put("userSeq", param.getString("userSeq"));
				whiteService.updateSortTable(map);
			}
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
			if(insertList.size()>0) ledgerMapper.insertPurDtlList(insertList);	
			if(updateList.size()>0) ledgerMapper.updatePurDtlList(updateList);
			if(deleteList.size()>0) {
				ledgerMapper.deletePurDtlList(deleteList);
				
				WhiteMap map = new WhiteMap();
				map.put("tableNm", "purpose_detail");
				map.put("firstSeqNm", "pur_dtl_seq");				
				map.put("secondSeqNm", "pur_seq");				
				map.put("secondSeq", deleteList.get(0).getString("purSeq"));				
				map.put("columnNm", "pur_dtl_order");
				map.put("userSeq", param.getString("userSeq"));
				whiteService.updateSortTable(map);
			}
			return 1;
		}
	}
	
	/**
	 * 해당 유저 사용수단 리스트
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectMeansList(WhiteMap param){		
		return ledgerMapper.selectMeansList(param);	
	}
	
	/**
	 * 해당 유저 사용수단 리스트 반영
	 * @param parma
	 * @return
	 * 1 : 정상처리.
	 * -1 : userSeq 바르지 않음.
	 * -2 : 가계부 테이블에 사용되어 있음. 
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int applyMeansList(WhiteMap param) {
		List<WhiteMap> meansList = param.convertListWhiteMap("list", true);
		
		List<WhiteMap> deleteList = new ArrayList<WhiteMap>();
		List<WhiteMap> insertList = new ArrayList<WhiteMap>();
		List<WhiteMap> updateList = new ArrayList<WhiteMap>();
		StringBuilder sb = new StringBuilder();
		
		for(int i=0; i<meansList.size(); i++) {			
			
			sb.append(meansList.get(i).get("meansSeq")).append(",");
			
			if("delete".equals(meansList.get(i).get("_state"))) {
				deleteList.add(meansList.get(i));				
			}else if("insert".equals(meansList.get(i).get("_state"))) {
				insertList.add(meansList.get(i));
			}else {
				updateList.add(meansList.get(i));				
			}
		}
		
		sb.setLength(sb.length() - 1);
		param.put("verifyMeansSeqList", sb.toString());		
		
		if(ledgerMapper.selectVerifyMeansSeqStrList(param) > 0) {
			return -1;
		}else if(deleteList.size() > 0 && ledgerMapper.selectIsUsedMeansRec(deleteList) > 0) {				
			return -2;
		}else {			
			if(insertList.size() > 0) {
				Collections.reverse(insertList);
				ledgerMapper.insertMeansList(insertList);	
			}
			if(updateList.size() > 0) ledgerMapper.updateMeansList(updateList);
			if(deleteList.size() > 0) {
				ledgerMapper.deleteMeansList(deleteList);
				
				WhiteMap map = new WhiteMap();
				map.put("tableNm", "MEANS");
				map.put("firstSeqNm", "MEANS_SEQ");				
				map.put("columnNm", "MEANS_ORDER");
				map.put("userSeq", param.getString("userSeq"));
				whiteService.updateSortTable(map);
			}
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
	 * -9 : 목적타입이 이동이 아닌 경우에서 meansSeq와 moveSeq가 같지 않는 경우
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
		WhiteMap meansSeqMap = White.convertListToMap(this.selectMeansList(param), "meansSeq", "meansNm");
		
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
			str = list.get(i).getString("meansSeq");			
			if(meansSeqMap.get(str) == null) return -5;			
			
			//목적 검사
			str = list.get(i).getString("purSeq");			
			if(purSeqMap.get(str) == null) return -6;
			
			//목적타입이 이동인 경우 검사
			if("LED003".equals(purTypeMap.get(str))) {
				String moveSeq = list.get(i).getString("moveSeq");
				if(meansSeqMap.get(moveSeq) == null) return -7;				
				if(moveSeq.equals(list.get(i).getString("meansSeq"))) return -8;
			//목적타입이 이동이 아닌 경우 검사//이동인경우 meansSeq와 moveSeq같도록 수정
			}else {
				str = list.get(i).getString("meansSeq");
				if(str == null) return -9;
				else if(!str.equals(list.get(i).getString("moveSeq"))) return -9;
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
				case "LED001":
					if(money <= 0) return -11; break;
				case "LED002":
				case "LED003":
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
	 * 금전기록 수정 및 삭제
	 * @param param
	 * @return 
	 * errorCode
	 * -1 : 날짜값이 정상적이지 않는 경우
	 * -2 : 위치값 길이 오버 (20자)
	 * -3 : 내용값 널값이거나 빈값
	 * -4 : 내용값 길이 오버 (50자)
	 * -5 : 사용수단 seq값 널값인 경우
	 * -6 : 목적 seq값 널인 경우
	 * -7 : 목적타입이 이동인 경우에서 받는곳이 널값인 경우
	 * -8 : 목적타입이 이동인 경우에서 보내는곳과 받는곳이 같은 경우
	 * -9 : 목적타입이 이동이 아닌 경우에서 meansSeq와 moveSeq가 같지 않는 경우
	 * -10 : 상세목적이 목적의 하위그룹에 속하지 않는 경우
	 * -11 : 금액값이 정상적이지 않는 경우
	 * deleteCnt or updateCnt : 갯수
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap applyRecordList(WhiteMap param) {		
		List<WhiteMap> updateList = param.convertListWhiteMap("updateList", true);
		List<WhiteMap> deleteList = param.convertListWhiteMap("deleteList", true);
		
		List<WhiteMap> purList = this.selectPurList(param);
		
		WhiteMap purSeqMap = White.convertListToMap(purList, "purSeq", "purpose");	
		WhiteMap purTypeMap = White.convertListToMap(purList, "purSeq", "purType");	
		WhiteMap purDtlSeqMap = White.convertListToMap(this.selectPurDtlList(param), "purDtlSeq", "purSeq");
		WhiteMap meansSeqMap = White.convertListToMap(this.selectMeansList(param), "meansSeq", "meansNm");
		
		String str = null;
		WhiteMap result = new WhiteMap();
				
		for(int i=0; i<updateList.size(); i++) {			
			//날짜 검사
			str = updateList.get(i).getString("recordDate");
			if(!White.dateCheck(str, "yyyy-MM-dd HH:mm")) {
				result.put("errorCode", -1);
				return result;
			}
			
			//위치 검사
			str = updateList.get(i).getString("position");			
			if(str.length() > Constant.POSITION_LENGTH) {
				result.put("errorCode", -2);
				return result;
			}
			
			//내용 검사
			str = updateList.get(i).getString("content");	
			if(str == null || "".equals(str)) {
				result.put("errorCode", -3);
				return result;
			}else if(str.length() > Constant.CONTENT_LENGTH) {
				result.put("errorCode", -4);
				return result;
			}
			
			//사용수단 검사
			str = updateList.get(i).getString("meansSeq");			
			if(meansSeqMap.get(str) == null) {
				result.put("errorCode", -5);
				return result;			
			}
			
			//목적 검사
			str = updateList.get(i).getString("purSeq");			
			if(purSeqMap.get(str) == null) {
				result.put("errorCode", -6);
				return result;
			}
			
			//목적타입이 이동인 경우 검사
			if("LED003".equals(purTypeMap.get(str))) {
				String moveSeq = updateList.get(i).getString("moveSeq");
				if(meansSeqMap.get(moveSeq) == null) {
					result.put("errorCode", -7);
					return result;				
				}
				if(moveSeq.equals(updateList.get(i).getString("meansSeq"))){
					result.put("errorCode", -8);
					return result;
				}
			//목적타입이 이동이 아닌 경우 검사//이동인경우 meansSeq와 moveSeq같도록 수정
			}else {
				str = updateList.get(i).getString("meansSeq");
				if(str == null) {
					result.put("errorCode", -9);
					return result;
				}else if(!str.equals(updateList.get(i).getString("moveSeq"))) {
					result.put("errorCode", -9);
					return result;
				}
			}
			
			//상세목적 검사
			str = updateList.get(i).getString("purDtlSeq");			
			if(!"".equals(str)) {
				if(!updateList.get(i).getString("purSeq").equals(purDtlSeqMap.get(str))) {
					result.put("errorCode", -10);
					return result;
				}
			}		
			
			//금액 검사
			str = updateList.get(i).getString("money");
			try {
				int money = Integer.parseInt(str);
				switch(purTypeMap.get(updateList.get(i).getString("purSeq")).toString()) {
				case "LED001":
					if(money <= 0) {
						result.put("errorCode", -11);
						return result;
					}
					break;
				case "LED002":
				case "LED003":
					if(money >= 0) {
						result.put("errorCode", -11);
						return result;
					}break;
				default:
					result.put("errorCode", -11);
					return result;				
				}
				
			}catch (NumberFormatException e) {
				result.put("errorCode", -11);
				return result;
			}
		}		
		
		if(deleteList.size()!=0) result.put("deleteCnt", ledgerMapper.deleteRecordList(deleteList));
		if(updateList.size()!=0) result.put("updateCnt", ledgerMapper.updateRecordList(updateList));
		return result;
	}
	
	
	/**
	 * 해당 유저 가계부 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectLedgerList(WhiteMap param){
		List<WhiteMap> list = ledgerMapper.selectLedgerList(param);
		if("DESC".equals(param.get("sort"))){
			Collections.reverse(list);
		}
		return list;
	}
	/**
	 * 사용자의 계산된 가계부 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectLedgerCalcList(WhiteMap param){
		WhiteMap map = null;
		
		//사용수단 조회
		List<WhiteMap> meansList = ledgerMapper.selectMeansList(param);
		
		//금전기록 조회
		map = new WhiteMap();
		map.put("userSeq", param.getInt("userSeq"));
		map.put("startDate", param.getString("startDate"));
		map.put("endDate", param.getString("endDate"));
		List<WhiteMap> ledgerList = ledgerMapper.selectLedgerList(param);
		
		//금전기록 기간 조회시 기간 이전  각각(현금, 은행등등) 금액 데이터 합산
		List<WhiteMap> pastList = new ArrayList<WhiteMap>();
		
		for(int i=0; i<meansList.size(); i++) {
			map = new WhiteMap();
			map.put("meansNo", "means"+i);
			map.put("meansSeq", meansList.get(i).getInt("meansSeq"));
			map.put("userSeq", param.getInt("userSeq"));
			map.put("startDate", param.getString("startDate"));			
			pastList.add(map);
		}		
		WhiteMap pastCal = ledgerMapper.selectPastCalLedger(pastList);		
		
		//총합계
		int amount = 0;		
		//수단(은행)별금액  금액증감
		int m = 0;		
		WhiteMap moneyMap = new WhiteMap();		
		for(int i=0; i<meansList.size(); i++) {
			m = pastCal == null ? 0 : pastCal.getInt("means"+i);
			moneyMap.put(meansList.get(i).getString("meansSeq"), m);			
			amount += m;
		}
		
		String meansSeq, moveSeq, meansNo = null;
		for(int i=0; i<ledgerList.size(); i++) {			
			//현금이동일때는 금액증감 제외
			if("LED003".equals(ledgerList.get(i).getString("purType"))) {
				ledgerList.get(i).put("amount", amount);				
			}else {
				amount += ledgerList.get(i).getInt("money");
				ledgerList.get(i).put("amount", amount);
			}
			
			//각각 수단(은행) money 증감
			meansSeq = ledgerList.get(i).getString("meansSeq");
			moneyMap.put(meansSeq, moneyMap.getInt(meansSeq) + ledgerList.get(i).getInt("money"));					
			
			//금액이동시 받는쪽 추가
			if("LED003".equals(ledgerList.get(i).getString("purType"))) {
				moveSeq = ledgerList.get(i).getString("moveSeq");				
				moneyMap.put(moveSeq, moneyMap.getInt(moveSeq) + Math.abs(ledgerList.get(i).getInt("money")));
			}
			
			//수단(은행)별 추가
			for(int j=0; j<meansList.size(); j++) {
				meansNo = "no" + meansList.get(j).getString("meansSeq");				
				ledgerList.get(i).put(meansNo, moneyMap.getInt(meansList.get(j).getString("meansSeq")));
			}
		}		
		
		String purSeq = White.isEmptyRtn(param.getString("purSeq"));
		String purDtlSeq =  White.isEmptyRtn(param.getString("purDtlSeq"));
		meansSeq = White.isEmptyRtn(param.getString("meansSeq"));
		
		if(purSeq != null || purDtlSeq != null || meansSeq != null) {
			Iterator<WhiteMap> iter = ledgerList.iterator();			
			if(purSeq != null) {
				while (iter.hasNext()) {
					map = iter.next();			 
					if(purSeq != null && !purSeq.equals(map.get("purSeq").toString())) {
						iter.remove();
					}
				}
			}			
			if(purDtlSeq != null) {
				iter = ledgerList.iterator();
				while (iter.hasNext()) {
					map = iter.next();			 
					if(purDtlSeq != null && !purDtlSeq.equals(map.get("purDtlSeq").toString())) {
						iter.remove();
					}
				}
			}
			if(meansSeq != null) {
				iter = ledgerList.iterator();
				while (iter.hasNext()) {
					map = iter.next();			 
					if(meansSeq != null && !meansSeq.equals(map.get("meansSeq").toString())) {
						iter.remove();
					}
				}
			}
		}
		Collections.reverse(ledgerList);
		return ledgerList;
	}	
	
	/** @deprecated 새로개발중
	 * 해당 유저 가계부 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectRecordList(WhiteMap param){
		return ledgerMapper.selectRecordList(param);
	}
	
	/** @deprecated 새로개발중
	 * 해당 유저 가계부 조회(금액 합산)
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectRecordSumList(WhiteMap param){
		
		List<WhiteMap> meansList = this.selectMeansList(param);
		//금전기록 기간 조회시 기간 이전  각각(현금, 은행등등) 금액 데이터 합산
		List<WhiteMap> pastRecList = new ArrayList<WhiteMap>();
		WhiteMap map = null;
		for(int i=0; i<meansList.size()+1; i++) {
			map = new WhiteMap();
			if(i==0) {
				map.put("meansNm", "cash");
				map.put("meansSeq", 0);				
				map.put("userSeq", param.getInt("userSeq"));
				map.put("startDate", param.getString("startDate"));
			}else {
				map.put("meansNm", "means"+(i-1));
				map.put("meansSeq", meansList.get(i-1).getInt("meansSeq"));
				map.put("userSeq", param.getInt("userSeq"));
				map.put("startDate", param.getString("startDate"));
			}
			pastRecList.add(map);
		}		
		WhiteMap pastRec = ledgerMapper.selectPastCalLedgerOLD(pastRecList);
		
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
		for(int i=0; i<meansList.size(); i++) {
			m = pastRec == null ? 0 : pastRec.getInt("means"+i);
			moneyMap.put(meansList.get(i).getString("meansSeq"), m );			
			amount += m;
		}
		for(int i=0; i<recList.size(); i++) {			
			//현금이동일때는 금액증감 제외, purSeq가 0인값은 금액이동
			if("LED003".equals(recList.get(i).getString("purType"))) {
				recList.get(i).put("amount", amount);
			}else {
				amount += recList.get(i).getInt("money");
				recList.get(i).put("amount", amount);
			}
			//현금쪽 각 행마다 money 증감
			if("0".equals(recList.get(i).getString("meansSeq"))) {				
				int cash = moneyMap.getInt("0");
				cash += recList.get(i).getInt("money");
				moneyMap.put("0", cash);
			//각각은행 money 증감
			}else{				
				String meansSeq = recList.get(i).getString("meansSeq");
				int meansMoney = moneyMap.getInt(meansSeq);
				meansMoney += recList.get(i).getInt("money");
				moneyMap.put(meansSeq, meansMoney);				
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
			recList.get(i).put("meansIdxLen", meansList.size()-1);
			for(int j=0; j<meansList.size(); j++) { 
				recList.get(i).put(meansList.get(j).getString("meansInfo"), moneyMap.getInt(meansList.get(j).getString("meansSeq")));
				//recList.get(i).put("means"+j, moneyMap.getInt(bankList.get(j).getString("meansSeq")));
			}						
		}		
		return recList;			
	}
	
	/**
	 * 가계부 첫 입력 날짜 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectFirstRecordDate(WhiteMap param) {
		WhiteMap result = ledgerMapper.selectFirstRecordDate(param);
		if(result == null) {
			result = new WhiteMap();
			result.put("firstDate", White.getTodayDate());
		}		
		return result;			
	}
	
	/**
	 * 가계부 통계 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectLedgerStats(WhiteMap param) {

		WhiteMap result = new WhiteMap();
		switch(param.getString("type")) {
		case "monthIE":			
			List<WhiteMap> dateList = new ArrayList<WhiteMap>();			
			WhiteMap stendDate = null;
			int monCnt = param.getInt("monthCnt");
			String stdate = param.getString("stdate");			
			if("".equals(stdate)) stdate = null;
			
			for(int i=0, j=(monCnt-1)*-1; i<monCnt; i++, j++) {			
				stendDate = new WhiteMap();
				stendDate.put("userSeq", param.get("userSeq"));
				stendDate.put("startDate", White.getFirstDate(White.dateMonthCalculate(stdate == null ? White.getTodayDate() : stdate, j))+" 00:00:00");
				stendDate.put("endDate", White.getLastDate(White.dateMonthCalculate(stdate == null ? White.getTodayDate() : stdate, j))+" 23:59:59");
				dateList.add(stendDate);
			}
			
			result.put("amount", ledgerMapper.selectPrevAmount(dateList.get(0)));
			result.put("list", ledgerMapper.selectLedgerMonthIEStats(dateList));		
			break;
		case "monthPur":			
			param.put("startDate", White.getFirstDate(param.getString("stdate"))+" 00:00:00");
			param.put("endDate", White.getLastDate(param.getString("stdate"))+" 23:59:59");
			
			if(param.getInt("inEx") == 0) param.put("purType", "LED001");
			else param.put("purType", "LED002");
			
			result.put("list", ledgerMapper.selectLedgerMonthPurStats(param));
			break;
		case "monthPurDtl":
			param.put("startDate", White.getFirstDate(param.getString("stdate"))+" 00:00:00");
			param.put("endDate", White.getLastDate(param.getString("stdate"))+" 23:59:59");
			
			result.put("list", ledgerMapper.selectLedgerMonthPurDtlStats(param));
			break;
		}
		return result;		
	}
}
