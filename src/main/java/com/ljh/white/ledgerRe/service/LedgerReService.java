package com.ljh.white.ledgerRe.service;

import java.util.List;
import java.util.Map;

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
	public List<WhiteMap> selectBankList(WhiteMap paramMap){		
		return ledgerReMapper.selectBankList(paramMap);	
	}
	/**
	 * 개발중...
	 * @param paramMap
	 * @return
	 */
	public List<WhiteMap> selectRecordList(WhiteMap paramMap, List<WhiteMap> bankList) {		
						
		List<WhiteMap> recList = ledgerReMapper.selectRecordList(paramMap);	
		
		//총계 변수에 금액 증감
		int amount = 0;		
		
		//현금,은행별금액  금액증감
		WhiteMap moneyMap = new WhiteMap();
		moneyMap.put("0", 0);
		for(int k=0; k<bankList.size(); k++) {
			moneyMap.put(bankList.get(k).getString("userBankSeq"), 0);
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
			if(recList.get(i).get("bankSeq")==null || 
					"".equals(recList.get(i).getString("bankSeq")) || 
					"0".equals(recList.get(i).getString("bankSeq"))) {
				
				int cash = moneyMap.getInt("0");
				cash += recList.get(i).getInt("money");
				moneyMap.put("0", cash);			
			}else{
				
				String bankSeq = recList.get(i).getString("bankSeq");
				int bankMoney = moneyMap.getInt(bankSeq);
				bankMoney += recList.get(i).getInt("money");
				moneyMap.put(bankSeq, bankMoney);				
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
