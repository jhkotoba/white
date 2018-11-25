package com.ljh.white.ledger.controller;

import java.util.List;

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
	
	/**
	 * 해당유저 목적, 상세목적, 목적타입 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectAllPurList.ajax" )
	public WhiteMap selectAllPurList(HttpServletRequest request){
		
		WhiteMap param = new WhiteMap(request);	
		WhiteMap result = new WhiteMap();
		
		result.put("purList", ledgerService.selectPurList(param));
		result.put("purDtlList", ledgerService.selectPurDtlList(param));
		result.put("purTypeList", whiteService.selectCodeList(param));
		
		return result;
	}
	
	/**
	 * 해당유저 목적 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectPurList.ajax" )
	public List<WhiteMap> selectPurList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return ledgerService.selectPurList(param);
	}
	
	/**
	 * 해당유저 목적 반영
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/applyPurList.ajax" )
	public int applyPurList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return ledgerService.applyPurList(param);
	}
	
	/**
	 * 해당유저 상세목적 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectPurDtlList.ajax" )
	public List<WhiteMap> selectPurDtlList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return ledgerService.selectPurDtlList(param);
	}
	
	/**
	 * 해당유저 상세목적 반영
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/applyPurDtlList.ajax" )
	public int applyPurDtlList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return ledgerService.applyPurDtlList(param);
	}
	
	/**
	 * 해당유저 은행목록 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectBankList.ajax" )
	public List<WhiteMap> selectBankList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return ledgerService.selectBankList(param);
	}
	
	/**
	 * 해당유저 은행목록 반영
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/applybankList.ajax" )
	public int applybankList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return ledgerService.applybankList(param);
	}
	
}
