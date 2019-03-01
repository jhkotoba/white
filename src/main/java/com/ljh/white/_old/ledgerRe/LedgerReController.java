package com.ljh.white._old.ledgerRe;

import java.text.ParseException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.memo.service.MemoService;

@RestController
public class LedgerReController {

	private static Logger logger = LogManager.getLogger(LedgerReController.class);
	
	@Resource(name = "LedgerReService")
	private LedgerReService ledgerReService;
	
	@Resource(name = "MemoService")
	private MemoService memoService;
	
	@RequestMapping(value="/ledgerRe/selectPurBankList.ajax" )
	public WhiteMap selectPurBankList(HttpServletRequest request){
		logger.debug("selectPurBankList Start");
		
		WhiteMap param = new WhiteMap(request);

		WhiteMap result = new WhiteMap();		
		result.put("purList", ledgerReService.selectPurList(param));
		result.put("purDtlList", ledgerReService.selectPurDtlList(param));
		result.put("bankList", ledgerReService.selectBankList(param));
		return result;
	}
	
	@RequestMapping(value="/ledgerRe/selectRecordList.ajax" )
	public WhiteMap selectRecordList(HttpServletRequest request){
		logger.debug("selectRecordList Start");
		
		WhiteMap param = new WhiteMap(request);
		List<WhiteMap> bankList = ledgerReService.selectBankList(param);
		
		WhiteMap result = new WhiteMap(request);		
		result.put("recList", ledgerReService.selectRecordList(param, bankList));
		if("index".equals(param.get("mode"))){
			result.put("purList", ledgerReService.selectPurList(param));
			result.put("purDtlList", ledgerReService.selectPurDtlList(param));
			result.put("bankList", bankList);
		}	
		
		return result;
	}
	
	@RequestMapping(value="/ledgerRe/insertRecordList.ajax" )
	public int insertRecordList(HttpServletRequest request){
		logger.debug("insertRecordList Start");
		
		WhiteMap param = new WhiteMap(request);	
		return ledgerReService.insertRecordList(param);
	}
	
	@RequestMapping(value="/ledgerRe/updateDeleteRecordList.ajax" )
	public WhiteMap updateDeleteRecordList(HttpServletRequest request){
		logger.debug("updateDeleteRecordList Start");
		
		WhiteMap param = new WhiteMap(request);	
		return ledgerReService.updateDeleteRecordList(param);
	}
	
	@RequestMapping(value="/ledgerRe/selectPurAndDtlList.ajax" )
	public WhiteMap selectPurAndDtlList(HttpServletRequest request){
		logger.debug("selectPurposeList Start");
		
		WhiteMap param = new WhiteMap(request);	
		
		WhiteMap result = new WhiteMap();		
		result.put("purList", ledgerReService.selectPurList(param));			
		result.put("purDtlList", ledgerReService.selectPurDtlList(param));		
		return result;
	}
	
	@RequestMapping(value="/ledgerRe/inUpDelPurList.ajax" )
	public WhiteMap inUpDelPurList(HttpServletRequest request){
		logger.debug("inUpDelPurList Start");
		
		WhiteMap param = new WhiteMap(request);		
		return ledgerReService.inUpDelPurList(param);		
	}
	
	@RequestMapping(value="/ledgerRe/inUpDelPurDtlList.ajax" )
	public WhiteMap inUpDelPurDtlList(HttpServletRequest request){
		logger.debug("inUpDelPurDtlList Start");
		
		WhiteMap param = new WhiteMap(request);		
		return ledgerReService.inUpDelPurDtlList(param);
	}
	
	@RequestMapping(value="/ledgerRe/selectBankList.ajax" )
	public List<WhiteMap> selectBankList(HttpServletRequest request){
		logger.debug("selectBankList Start");
		
		WhiteMap param = new WhiteMap(request);		
		return ledgerReService.selectBankList(param);
	}
	
	@RequestMapping(value="/ledgerRe/inUpDelBankList.ajax" )
	public WhiteMap inUpDelBankList(HttpServletRequest request){
		logger.debug("inUpDelBankList Start");
		
		WhiteMap param = new WhiteMap(request);		
		return ledgerReService.inUpDelBankList(param);
	}
	
	@RequestMapping(value="/ledgerRe/selectMonthStats.ajax" )
	public WhiteMap selectStatsList(HttpServletRequest request) throws ParseException{
		logger.debug("selectStatsList Start");
		
		WhiteMap param = new WhiteMap(request);		
		
		WhiteMap result = new WhiteMap();		
		result.put("IEA", ledgerReService.selectMonthIEAStats(param));
		result.put("CB", ledgerReService.selectMonthCBStats(param));
		result.put("P", ledgerReService.selectMonthPStats(param));		
		return result;
	}
}
