package com.ljh.white.ledgerRe.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.ledgerRe.mapper.LedgerReMapper;



@Service("LedgerReService")
public class LedgerReService {
	
	@Resource(name = "LedgerReMapper")
	private LedgerReMapper ledgerReMapper;
	
	/**
	 * 해당 유저 은행리스트
	 * @param paramMap
	 * @return
	 */
	public List<WhiteMap> selectBankList(WhiteMap param){		
		return ledgerReMapper.selectBankList(param);	
	}
	/**
	 * 금전기록 조회
	 * @param paramMap
	 * @return
	 */
	public List<WhiteMap> selectRecordList(WhiteMap param, List<WhiteMap> bankList) {		
						
		//금전기록 기간 조회시 기간 이전  각각 금액 데이터 합산
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
				map.put("bankSeq", bankList.get(i-1).getInt("userBankSeq")); //userBankSeq -> bankSeq 추후  컬럼명 수정 필요
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
		WhiteMap moneyMap = new WhiteMap();
		moneyMap.put("0", pastRec == null ? 0 : pastRec.getInt("cash"));
		for(int i=0; i<bankList.size(); i++) {
			moneyMap.put(bankList.get(i).getString("userBankSeq"), pastRec == null ? 0 : pastRec.getInt("bank"+i) );
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
				recList.get(i).put("bank"+j, moneyMap.getInt(bankList.get(j).getString("userBankSeq")));
			}
						
		}
		
		return recList;
	}
}
