package com.ljh.white.ledgerRe.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.ledgerRe.service.LedgerReService;

@Controller
public class LedgerReController {

	private static Logger logger = LogManager.getLogger(LedgerReController.class);
	
	@Resource(name = "LedgerReService")
	private LedgerReService ledgerReService;
	
	@RequestMapping(value="/ledgerReMain.do" )
	public String ledgerReMain(HttpServletRequest request){
		logger.debug("ledgerReTest Start");
		
		return "ledgerRe/ledgerReMain.jsp";
		
		
	}
	
	@RequestMapping(value="/selectRecordList.do" )
	public String selectRecordList(HttpServletRequest request){
		
		WhiteMap paramMap = new WhiteMap(request);		
		List<WhiteMap> bankList = ledgerReService.selectBankList(paramMap);
		
		request.setAttribute("bankList", new JSONArray(bankList));	
		request.setAttribute("recList", new JSONArray(ledgerReService.selectRecordList(paramMap, bankList)));			
		return "ledgerRe/ledgerReMain.jsp";
	}
}
