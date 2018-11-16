package com.ljh.white.ledger.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.service.WhiteService;
import com.ljh.white.ledger.service.LedgerService;

@RestController
public class LedgerController {

	@Resource(name = "LedgerService")
	private LedgerService ledgerService;
	
	@Resource(name = "WhiteService")
	private WhiteService whiteService;
	
	@RequestMapping(value="/ledger/selectAllPurList.ajax" )
	public WhiteMap selectAllPurList(HttpServletRequest request){
		
		WhiteMap param = new WhiteMap(request);	
		WhiteMap result = new WhiteMap();
		
		result.put("purList", ledgerService.selectPurList(param));
		result.put("purDtlList", ledgerService.selectPurDtlList(param));
		result.put("purTypeList", whiteService.selectCodeList(param));
		
		return result;
	}
}
