package com.ljh.white.ledgerRe.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.ledgerRe.mapper.LedgerReMapper;



@Service("LedgerReService")
public class LedgerReService {
	
	@Resource(name = "LedgerReMapper")
	private LedgerReMapper ledgerReMapper;
	
	/**
	 * 해당 유저 은행리스트
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectBankList(WhiteMap param){		
		return ledgerReMapper.selectBankList(param);	
	}
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurList(WhiteMap param) {		
		return ledgerReMapper.selectPurList(param);		
		
	}	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurDtlList(WhiteMap param) {		
		return ledgerReMapper.selectPurDtlList(param);		
		
	}
	/**
	 * 금전기록 조회
	 * @param paramMap
	 * @return
	 */
	public List<WhiteMap> selectRecordList(WhiteMap param, List<WhiteMap> bankList) {		
						
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
		WhiteMap pastRec = ledgerReMapper.selectCalPastRecord(pastRecList);
		
		//금전기록 조회
		List<WhiteMap> recList = ledgerReMapper.selectRecordList(param);
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
			if(recList.get(i).getInt("purSeq")==0) {
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
				recList.get(i).put("bank"+j, moneyMap.getInt(bankList.get(j).getString("bankSeq")));
			}
						
		}
		
		return recList;
	}
	
	/**
	 * 금전기록List insert
	 * @param list
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int insertRecordList(WhiteMap param) {
		
		List<WhiteMap> list = param.getListWhiteMap("inList");
		
		for(int i=0; i<list.size(); i++) {
			list.get(i).put("userSeq", param.getInt("userSeq"));
		}		
		return ledgerReMapper.insertRecordList(list);	
	}
	
	/**
	 * 금전기록List update, delete
	 * @param list
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap updateDeleteRecordList(WhiteMap param) {
		
		List<WhiteMap> upList = param.getListWhiteMap("upList");
		List<WhiteMap> delList = param.getListWhiteMap("delList");
		
		WhiteMap resultMap = new WhiteMap();
		if(upList.size() > 0 ) {			
			resultMap.put("upCnt", ledgerReMapper.updateRecordList(upList));	
		}else {
			resultMap.put("upCnt", 0);	
		}
		
		if(delList.size() > 0) {			
			resultMap.put("delCnt", ledgerReMapper.deleteRecordList(delList));
		}else {
			resultMap.put("delCnt", 0);	
		}
		
		return resultMap;		
	}
	
	/**
	 * 목적 insert, update, delete
	 * @param list
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap inUpDelPurList(WhiteMap param) {
		
		List<WhiteMap> inList = param.getListWhiteMap("inList");
		List<WhiteMap> upList = param.getListWhiteMap("upList");
		List<WhiteMap> delList = param.getListWhiteMap("delList");
		
		WhiteMap resultMap = new WhiteMap();
		
		if(delList.size() > 0) {
			if(ledgerReMapper.selectIsUsedPurposeRec(delList)>0) {
				resultMap.put("msg", "recodePurUsed");
				return resultMap;
			}else if(ledgerReMapper.selectIsUsedPurposePurDtl(delList)>0) {
				resultMap.put("msg", "purDtlPurUsed");
				return resultMap;
			}else {
				resultMap.put("delCnt", ledgerReMapper.deletePurList(delList));
			}
		}else {
			resultMap.put("delCnt", 0);	
		}
		
		if(inList.size() > 0 ) {
			
			for(int i=0; i<inList.size(); i++) {
				inList.get(i).put("userSeq", param.getInt("userSeq"));
			}			
			resultMap.put("inCnt", ledgerReMapper.insertPurList(inList));	
		}else {
			resultMap.put("inCnt", 0);	
		}
		
		if(upList.size() > 0 ) {			
			resultMap.put("upCnt", ledgerReMapper.updatePurList(upList));	
		}else {
			resultMap.put("upCnt", 0);	
		}		
		
		return resultMap;
	}
	
	/**
	 * 상세목적 insert, update, delete
	 * @param list
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap inUpDelPurDtlList(WhiteMap param) {
		
		List<WhiteMap> inList = param.getListWhiteMap("inList");
		List<WhiteMap> upList = param.getListWhiteMap("upList");
		List<WhiteMap> delList = param.getListWhiteMap("delList");
		
		WhiteMap resultMap = new WhiteMap();
		
		if(delList.size() > 0) {
			if(ledgerReMapper.selectIsUsedPurDtl(delList)>0) {
				resultMap.put("msg", "purDtlUsed");
				return resultMap;				
			}else {
				resultMap.put("delCnt", ledgerReMapper.deletePurDtlList(delList));
			}
		}else {
			resultMap.put("delCnt", 0);	
		}
		
		if(inList.size() > 0 ) {
			
			for(int i=0; i<inList.size(); i++) {
				inList.get(i).put("userSeq", param.getInt("userSeq"));
			}			
			resultMap.put("inCnt", ledgerReMapper.insertPurDtlList(inList));	
		}else {
			resultMap.put("inCnt", 0);	
		}
		
		if(upList.size() > 0 ) {			
			resultMap.put("upCnt", ledgerReMapper.updatePurDtlList(upList));	
		}else {
			resultMap.put("upCnt", 0);	
		}
		
		return resultMap;
	}
	
	
	/**
	 * 은행 insert, update, delete
	 * @param list
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap inUpDelBankList(WhiteMap param) {
		
		List<WhiteMap> inList = param.getListWhiteMap("inList");
		List<WhiteMap> upList = param.getListWhiteMap("upList");
		List<WhiteMap> delList = param.getListWhiteMap("delList");
		
		WhiteMap resultMap = new WhiteMap();
		
		if(delList.size() > 0) {
			if(ledgerReMapper.selectIsUsedBank(delList)>0) {
				resultMap.put("msg", "bankUsed");
				return resultMap;				
			}else {
				resultMap.put("delCnt", ledgerReMapper.deleteBankList(delList));
			}
		}else {
			resultMap.put("delCnt", 0);	
		}
		
		if(inList.size() > 0 ) {
			
			for(int i=0; i<inList.size(); i++) {
				inList.get(i).put("userSeq", param.getInt("userSeq"));
			}			
			resultMap.put("inCnt", ledgerReMapper.insertBankList(inList));	
		}else {
			resultMap.put("inCnt", 0);	
		}
		
		if(upList.size() > 0 ) {			
			resultMap.put("upCnt", ledgerReMapper.updateBankList(upList));	
		}else {
			resultMap.put("upCnt", 0);	
		}
		
		return resultMap;
	}
	
	/**
	 * 가계부 통계 조회(수익, 지출, 누적)
	 * @param list
	 * @return
	 * @throws ParseException 
	 */
	public List<WhiteMap> selectMonthIEAStats(WhiteMap param) throws ParseException {
		
		int userSeq = param.getInt("userSeq");
		List<WhiteMap> resultList = null;		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		List<WhiteMap> dateList = new ArrayList<WhiteMap>();
		Date date = sdf.parse(param.getString("date"));
		Calendar cal = Calendar.getInstance();
		
		WhiteMap map = new WhiteMap();
		
		cal.setTime(date);		
		cal.add(Calendar.MONTH, -11);
		
		String startDate = sdf.format(cal.getTime());
		map.put("userSeq", userSeq);
		map.put("date", startDate);
		map.put("ym", map.getString("date").substring(0,7).replace("-", ""));	
		dateList.add(map);
		
		for(int i=0; i<11; i++) {				
			cal.add(Calendar.MONTH, 1);
			
			map = new WhiteMap();
			map.put("userSeq", userSeq);
			map.put("date", sdf.format(cal.getTime()));
			map.put("ym", map.getString("date").substring(0,7).replace("-", ""));
			dateList.add(map);
		}
		
		resultList =  ledgerReMapper.selectMonthIEAStats(dateList);
		
		param.put("startDate", startDate);
		int amount = ledgerReMapper.selectCalPastAmountRecord(param);
		resultList.get(0).put("stAmount", amount);
		
		return resultList;
	}
	/**
	 * 가계부 월별 통계 조회(현금, 은행별)
	 * @param list
	 * @return
	 * @throws ParseException 
	 */
	public List<WhiteMap> selectMonthCBStats(WhiteMap param) throws ParseException {
		
		List<WhiteMap> resultList = null;		
		List<WhiteMap> bankList = this.selectBankList(param);
		int userSeq = param.getInt("userSeq");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = sdf.parse(param.getString("date"));
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);		
		cal.add(Calendar.MONTH, -11);		
		String startDate = sdf.format(cal.getTime());		
		
		//금전기록 기간 조회시 기간 이전  각각(현금, 은행등등) 금액 데이터 합산
		List<WhiteMap> pastRecList = new ArrayList<WhiteMap>();
		WhiteMap map = null;
		for(int i=0; i<bankList.size()+1; i++) {
			map = new WhiteMap();
			if(i==0) {
				map.put("bankName", "cash");
				map.put("bankSeq", 0);				
				map.put("userSeq", param.getInt("userSeq"));
				map.put("startDate", startDate);
			}else {
				map.put("bankName", "bank"+(i-1));
				map.put("bankSeq", bankList.get(i-1).getInt("bankSeq"));
				map.put("userSeq", param.getInt("userSeq"));
				map.put("startDate", startDate);
			}
			pastRecList.add(map);
		}
		WhiteMap pastRec = ledgerReMapper.selectCalPastRecord(pastRecList);	
		
		//은행리스트 복제, 현금추가
		List<WhiteMap> CBList = new ArrayList<WhiteMap>();
		for(int i=0; i<bankList.size(); i++) {
			CBList.add(bankList.get(i).deepCopy());
		}
		
		for(int i=0; i<CBList.size(); i++) {		
			CBList.get(i).put("money", pastRec.get("bank"+i));			
		}
		map = new WhiteMap();
		map.put("bankName", "cash");
		map.put("bankSeq", 0);
		map.put("cash", pastRec.get("cash"));
		CBList.add(map);
		
		//현금, 은행별 시작날짜로부터 월별 합계 조회
		WhiteMap listMap = new WhiteMap();		
		List<WhiteMap> dateList = new ArrayList<WhiteMap>();
			
		for(int j=0; j<11; j++) {				
			cal.add(Calendar.MONTH, 1);
			
			map = new WhiteMap();
			map.put("userSeq", userSeq);
			map.put("date", sdf.format(cal.getTime()));
			map.put("ym", map.getString("date").substring(0,7).replace("-", ""));			
			dateList.add(map);
		}
		listMap.put("CBList", CBList);
		listMap.put("dateList", dateList);
		
		resultList =  ledgerReMapper.selectMonthCBStats(listMap);
		pastRec.put("date", "prevDate");
		resultList.add(0, pastRec);
		return resultList;
	}
	
	/**
	 * 가계부 월별 통계 조회(목적별)
	 * @param list
	 * @return
	 * @throws ParseException 
	 */
	public List<WhiteMap> selectMonthPStats(WhiteMap param) throws ParseException {
		
		return null;
	}
}
