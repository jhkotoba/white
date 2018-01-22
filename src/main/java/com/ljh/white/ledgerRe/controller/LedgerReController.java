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
	
	@RequestMapping(value="/ledgerRe/selectRecordList.do" )
	public String selectRecordList(HttpServletRequest request){
		
		WhiteMap param = new WhiteMap(request);		
		List<WhiteMap> bankList = ledgerReService.selectBankList(param);

		JSONObject result = new JSONObject();
		result.put("bankList", new JSONArray(bankList));
		result.put("recList", new JSONArray(ledgerReService.selectRecordList(param, bankList)));			
		request.setAttribute("result", result);	
		
		return "result.jsp";
	}
}
