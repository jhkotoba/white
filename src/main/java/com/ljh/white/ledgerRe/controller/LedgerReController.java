package com.ljh.white.ledgerRe.controller;

import java.text.ParseException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.ledgerRe.service.LedgerReService;
import com.ljh.white.memo.service.MemoService;

@Controller
public class LedgerReController {

	private static Logger logger = LogManager.getLogger(LedgerReController.class);
	
	@Resource(name = "LedgerReService")
	private LedgerReService ledgerReService;
	
	@Resource(name = "MemoService")
	private MemoService memoService;
	
	@RequestMapping(value="/ledgerRe" )
	public String ledgerReMain(HttpServletRequest request){
		logger.debug("ledgerRe Start");
		
		WhiteMap param = new WhiteMap(request);
		
		String navUrl = param.getString("navUrl");
		String sideUrl = param.getString("sideUrl");
		
		request.setAttribute("navUrl", navUrl);
		request.setAttribute("sideUrl", sideUrl);
		
		request.setAttribute("sectionPage", navUrl.replace("/", "")+sideUrl+".jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/selectPurBankList.ajax" )
	public String selectPurBankList(HttpServletRequest request){
		logger.debug("selectPurBankList Start");
		
		WhiteMap param = new WhiteMap(request);

		JSONObject result = new JSONObject();		
		result.put("purList", new JSONArray(ledgerReService.selectPurList(param)));
		result.put("purDtlList", new JSONArray(ledgerReService.selectPurDtlList(param)));
		result.put("bankList", new JSONArray(ledgerReService.selectBankList(param)));
		request.setAttribute("result", result);	
		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/selectRecordList.ajax" )
	public String selectRecordList(HttpServletRequest request){
		logger.debug("selectRecordList Start");
		
		WhiteMap param = new WhiteMap(request);
		List<WhiteMap> bankList = ledgerReService.selectBankList(param);

		JSONObject result = new JSONObject();		
		result.put("recList", new JSONArray(ledgerReService.selectRecordList(param, bankList)));
		if("index".equals(param.get("mode"))){
			result.put("purList", new JSONArray(ledgerReService.selectPurList(param)));
			result.put("purDtlList", new JSONArray(ledgerReService.selectPurDtlList(param)));
			result.put("bankList", new JSONArray(bankList));
		}		
		request.setAttribute("result", result);	
		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/insertRecordList.ajax" )
	public String insertRecordList(HttpServletRequest request){
		logger.debug("insertRecordList Start");
		
		WhiteMap param = new WhiteMap(request);	
	
		int cnt = ledgerReService.insertRecordList(param);
		request.setAttribute("result", cnt);
		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/updateDeleteRecordList.ajax" )
	public String updateDeleteRecordList(HttpServletRequest request){
		logger.debug("updateDeleteRecordList Start");
		
		WhiteMap param = new WhiteMap(request);	
	
		WhiteMap resultMap = ledgerReService.updateDeleteRecordList(param);
		request.setAttribute("result", new JSONObject(resultMap));
		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/selectPurAndDtlList.ajax" )
	public String selectPurAndDtlList(HttpServletRequest request){
		logger.debug("selectPurposeList Start");
		
		WhiteMap param = new WhiteMap(request);	
		
		JSONObject result = new JSONObject();		
		result.put("purList", new JSONArray(ledgerReService.selectPurList(param)));			
		result.put("purDtlList", new JSONArray(ledgerReService.selectPurDtlList(param)));			
		request.setAttribute("result", result);	
		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/inUpDelPurList.ajax" )
	public String inUpDelPurList(HttpServletRequest request){
		logger.debug("inUpDelPurList Start");
		
		WhiteMap param = new WhiteMap(request);		
		WhiteMap resultMap = ledgerReService.inUpDelPurList(param);
		request.setAttribute("result", new JSONObject(resultMap));		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/inUpDelPurDtlList.ajax" )
	public String inUpDelPurDtlList(HttpServletRequest request){
		logger.debug("inUpDelPurDtlList Start");
		
		WhiteMap param = new WhiteMap(request);		
		WhiteMap resultMap = ledgerReService.inUpDelPurDtlList(param);
		request.setAttribute("result", new JSONObject(resultMap));		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/selectBankList.ajax" )
	public String selectBankList(HttpServletRequest request){
		logger.debug("selectBankList Start");
		
		WhiteMap param = new WhiteMap(request);
		JSONObject result = new JSONObject();
		result.put("bankList", new JSONArray(ledgerReService.selectBankList(param)));				
		request.setAttribute("result", result);			
		return "result.jsp";
		
	}
	
	@RequestMapping(value="/ledgerRe/inUpDelBankList.ajax" )
	public String inUpDelBankList(HttpServletRequest request){
		logger.debug("inUpDelBankList Start");
		
		WhiteMap param = new WhiteMap(request);		
		WhiteMap resultMap = ledgerReService.inUpDelBankList(param);
		request.setAttribute("result", new JSONObject(resultMap));		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/selectMonthStats.ajax" )
	public String selectStatsList(HttpServletRequest request) throws ParseException{
		logger.debug("selectStatsList Start");
		
		WhiteMap param = new WhiteMap(request);		
		
		JSONObject result = new JSONObject();		
		result.put("IEA", new JSONArray(ledgerReService.selectMonthIEAStats(param)));
		result.put("CB", new JSONArray(ledgerReService.selectMonthCBStats(param)));
		result.put("P", new JSONArray(ledgerReService.selectMonthPStats(param)));
			
		request.setAttribute("result", result);	
		
		return "result.jsp";
	}
}
