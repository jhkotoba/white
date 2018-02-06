package com.ljh.white.ledgerRe.controller;

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
	
	@RequestMapping(value="/ledgerRe/ledgerReMain.do" )
	public String ledgerReMain(HttpServletRequest request){
		logger.debug("ledgerReTest Start");
		
		WhiteMap param = new WhiteMap(request);		
		
		String sectionPage = param.getString("move");		
		if("".equals(sectionPage) || sectionPage == null) sectionPage = "Main";
		
		switch(sectionPage){
		case "Main" :			
			param.put("memoType", "ledger");
			request.setAttribute("memoList", new JSONArray(memoService.selectMemoList(param)));
		case "Select" :			
		case "Insert" :	
			request.setAttribute("purList", new JSONArray(ledgerReService.selectPurList(param)));	
			request.setAttribute("purDtlList", new JSONArray(ledgerReService.selectPurDtlList(param)));
			request.setAttribute("bankList", new JSONArray(ledgerReService.selectBankList(param)));
			break;
		}
			
		request.setAttribute("sidePage", "ledgerRe/ledgerReSide.jsp");		
		request.setAttribute("sectionPage", "ledgerRe/ledgerRe"+sectionPage+".jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/ajax/selectRecordList.do" )
	public String selectRecordList(HttpServletRequest request){
		logger.debug("selectRecordList Start");
		
		WhiteMap param = new WhiteMap(request);		
		List<WhiteMap> bankList = ledgerReService.selectBankList(param);

		JSONObject result = new JSONObject();		
		result.put("recList", new JSONArray(ledgerReService.selectRecordList(param, bankList)));			
		request.setAttribute("result", result);	
		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/ajax/insertRecordList.do" )
	public String insertRecordList(HttpServletRequest request){
		logger.debug("insertRecordList Start");
		
		WhiteMap param = new WhiteMap(request);	
	
		int cnt = ledgerReService.insertRecordList(param);
		request.setAttribute("result", cnt);
		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/ajax/updateDeleteRecordList.do" )
	public String updateDeleteRecordList(HttpServletRequest request){
		logger.debug("updateDeleteRecordList Start");
		
		WhiteMap param = new WhiteMap(request);	
	
		WhiteMap resultMap = ledgerReService.updateDeleteRecordList(param);
		request.setAttribute("result", new JSONObject(resultMap));
		
		return "result.jsp";
	}
	
	@RequestMapping(value="/ledgerRe/ajax/selectPurAndDtlList.do" )
	public String selectPurposeList(HttpServletRequest request){
		logger.debug("selectPurposeList Start");
		
		WhiteMap param = new WhiteMap(request);	
		
		JSONObject result = new JSONObject();		
		result.put("purList", new JSONArray(ledgerReService.selectPurList(param)));			
		result.put("purDtlList", new JSONArray(ledgerReService.selectPurDtlList(param)));			
		request.setAttribute("result", result);	
		
		return "result.jsp";
	}
}
