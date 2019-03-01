package com.ljh.white._old.ledgerRe;

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
import com.ljh.white.common.Constant;
import com.ljh.white.common.White;



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
	 * 해당유저 목적 리스트
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurList(WhiteMap param) {		
		return ledgerReMapper.selectPurList(param);		
		
	}	
	/**
	 * 해당유저 상세목적 리스트
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
		
		List<WhiteMap> list = param.convertListWhiteMap("inList", true);
		if(!this.recordIntegrityCheck(list, param.getInt("userSeq"))) {
			return -1;
		}
		
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
		
		List<WhiteMap> upList = param.convertListWhiteMap("upList", false);
		List<WhiteMap> delList = param.convertListWhiteMap("delList", false);
		
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
		
		List<WhiteMap> inList = param.convertListWhiteMap("inList", true);
		List<WhiteMap> upList = param.convertListWhiteMap("upList", false);
		List<WhiteMap> delList = param.convertListWhiteMap("delList", false);
		
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
		
		List<WhiteMap> inList = param.convertListWhiteMap("inList", true);
		List<WhiteMap> upList = param.convertListWhiteMap("upList", false);
		List<WhiteMap> delList = param.convertListWhiteMap("delList", false);
		
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
		
		List<WhiteMap> inList = param.convertListWhiteMap("inList", true);
		List<WhiteMap> upList = param.convertListWhiteMap("upList", false);
		List<WhiteMap> delList = param.convertListWhiteMap("delList", false);
		
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
		
		List<WhiteMap> resultList = null;	
		
		List<WhiteMap> dateList = this.getDateList(param, 12);
		resultList =  ledgerReMapper.selectMonthIEAStats(dateList);
		
		param.put("startDate", dateList.get(0).getString("date"));
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
		List<WhiteMap> dateList = this.getDateList(param, 12);
		
		//금전기록 기간 조회시 기간 이전  각각(현금, 은행등등) 금액 데이터 합산
		List<WhiteMap> pastRecList = new ArrayList<WhiteMap>();
		WhiteMap map = null;
		for(int i=0; i<bankList.size()+1; i++) {
			map = new WhiteMap();
			if(i==0) {
				map.put("bankName", "cash");
				map.put("bankSeq", 0);				
				map.put("userSeq", param.getInt("userSeq"));
				map.put("startDate", dateList.get(0).getString("date"));
			}else {
				map.put("bankName", "bank"+bankList.get(i-1).getInt("bankSeq"));
				map.put("bankSeq", bankList.get(i-1).getInt("bankSeq"));
				map.put("userSeq", param.getInt("userSeq"));
				map.put("startDate", dateList.get(0).getString("date"));
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
		
		listMap.put("CBList", CBList);
		listMap.put("dateList", dateList);
		
		resultList =  ledgerReMapper.selectMonthCBStats(listMap);
		pastRec.put("date", "prevDate");
		pastRec.put("bankList", bankList);
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
		List<WhiteMap> resultList = null;
		List<WhiteMap> purList = this.selectPurList(param);
		
		WhiteMap listMap = new WhiteMap();
		listMap.put("purList", purList);
		listMap.put("dateList", this.getDateList(param, 4));
		resultList =  ledgerReMapper.selectMonthPStats(listMap);
		
		resultList.add(0, White.convertListToMap(purList, "purSeq", "purpose"));
		return resultList;
	}
	
	
	/**
	 * 가계부 테이블 money_record_re 데이터 무결성 체크(List)
	 * @param list
	 * @return
	 */
	private boolean recordIntegrityCheck(List<WhiteMap> list, int userSeq) {	
		
		String record = null;		
		WhiteMap param = new WhiteMap();
		param.put("userSeq", userSeq);
		
		WhiteMap purMap = White.convertListToMap(this.selectPurList(param), "purSeq", "purpose");		
		WhiteMap purDtlMap = White.convertListToMap(this.selectPurDtlList(param), "purDtlSeq", "purSeq");
		WhiteMap bankMap = White.convertListToMap(this.selectBankList(param), "bankSeq", "bankName");
		purMap.put("0", "move");
		bankMap.put("0", "cash");
		
		//데이터 체크			
		for(int i=0; i<list.size(); i++) {			
			
			//White.htmlReplace(list.get(i));
			//White.nullDelete(list.get(i));			
			
			record = list.get(i).getString("recordDate");			
			if(!White.dateCheck(record)) {
				return false;
			}
			
			record = list.get(i).getString("position");			
			if(record.length() > Constant.POSITION_LENGTH){
				return false;
			}			
						
			record = list.get(i).getString("content");		
			if(!(record.length() > 0 && record.length() < Constant.CONTENT_LENGTH)){
				return false;
			}
			
			record = list.get(i).getString("bankSeq");			
			if(bankMap.get(record) == null) {
				return false;
			}			
					
			record = list.get(i).getString("purSeq");			
			if(purMap.get(record) == null) {
				return false;
			}			
			
			if("0".equals(record)) {				
				String moveSeq = list.get(i).getString("moveSeq");				
				if(bankMap.get(moveSeq) == null) {
					return false;				
				}				
				if(moveSeq.equals(list.get(i).getString("bankSeq"))) {
					return false;
				}			
			}else {				
				if(!"".equals(list.get(i).getString("moveSeq"))){
					return false;
				}
			}
			
			record = list.get(i).getString("purDtlSeq");			
			if(!"".equals(record)) {
				if(!list.get(i).getString("purSeq").equals(purDtlMap.get(record))) {
					return false;				
				}
			}		
			
			record = list.get(i).getString("money");
			try {
				Integer.parseInt(record);
			}catch (NumberFormatException e) {
				return false;
			}
		}
		return true;
	}	
	
	/**
	 * 통계용 내부 날짜리스트 계산용 메소드
	 * @return
	 * @throws ParseException 
	 */
	private List<WhiteMap> getDateList(WhiteMap param, int count) throws ParseException{
		
		WhiteMap map = new WhiteMap();
		
		List<WhiteMap> dateList = new ArrayList<WhiteMap>();
		int userSeq = param.getInt("userSeq");
		int cnt = ((Math.abs(count)-1)*-1);
				
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		
		String startDate = "";
		if("".equals(param.getString("date")) || null == param.getString("date")) {
			cal.add(Calendar.MONTH, cnt);	
			startDate = sdf.format(cal.getTime());					
		}else {
			Date date = sdf.parse(param.getString("date"));			
			cal.setTime(date);		
			cal.add(Calendar.MONTH, cnt);
			startDate = sdf.format(cal.getTime());
		}		
		
		map.put("userSeq", userSeq);
		map.put("date", startDate);
		map.put("ym", map.getString("date").substring(0,7).replace("-", ""));	
		dateList.add(map);
		
		for(int i=0; i<(count-1); i++) {			
			cal.add(Calendar.MONTH, 1);
			
			map = new WhiteMap();
			map.put("userSeq", userSeq);
			map.put("date", sdf.format(cal.getTime()));
			map.put("ym", map.getString("date").substring(0,7).replace("-", ""));
			dateList.add(map);
		}
		return dateList;
	}
	
	/**
	 * Whiet.convertListToMap으로 수정
	 * 사용안함 추후 삭제
	 * 목적리스트  (ListWhiteMap) 
	 * purList에서 목적시퀀스번을 Key로 목적이름을 value로 한 WhiteMap 객체 생성
	 * @return
	 */
	/*private WhiteMap convertPurListToPurMap(List<WhiteMap> purList) {
		WhiteMap purMap = new WhiteMap();
		
		for(int i=0; i<purList.size(); i++) {
			purMap.put(purList.get(i).getString("purSeq"), purList.get(i).getString("purpose"));
		}
		return purMap;
	}*/
}
