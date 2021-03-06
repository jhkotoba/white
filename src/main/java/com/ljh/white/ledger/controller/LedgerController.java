package com.ljh.white.ledger.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.ledger.service.LedgerService;
import com.ljh.white.white.service.WhiteService;

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
		result.put("purTpList", whiteService.selectCodeList(param));
		
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
	 * 해당유저 사용수단 목록 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectMeansList.ajax" )
	public List<WhiteMap> selectMeansList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return ledgerService.selectMeansList(param);
	}
	
	/**
	 * 해당유저 사용수단 목록 반영
	 * @param request
	 * @return
	 */	
	@RequestMapping(value="/ledger/applyMeansList.ajax" )
	public int applyMeansList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return ledgerService.applyMeansList(param);
	}
	
	/**
	 * 가계부 초기 데이터 조회 : 해당유저 목적, 상세목적, 은행 리스트
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectLedgerInitData.ajax" )
	public WhiteMap selectLedgerInitData(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);
		WhiteMap result = new WhiteMap();		
		result.put("purList", ledgerService.selectPurList(param));
		result.put("purDtlList", ledgerService.selectPurDtlList(param));
		result.put("meansList", ledgerService.selectMeansList(param));
		return result;
	}
	
	/**
	 * 해당유저 가계부 기입
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/insertRecordList.ajax" )
	public int insertRecordList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);
		return ledgerService.insertRecordList(param);
	}
	
	/** @deprecated 새로개발중 -> selectLedgerList
	 * 가계부 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectRecordList.ajax" )
	public List<WhiteMap> selectRecordList(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);
		switch(param.getString("searchType")) {
		case "select":
			return ledgerService.selectRecordSumList(param);
		case "recent":
			if(param.get("schdTime")==null || "".equals(param.get("schdTime"))){
				param.put("schdTime", 1);
			}
		default:
		case "edit":
			return ledgerService.selectRecordList(param);
		}
	}
	
	
	/**
	 * 계산된 가계부 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectLedgerCalcList.ajax" )
	public List<WhiteMap> selectLedgerCalcList(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);
		return ledgerService.selectLedgerCalcList(param);		
	}
	
	/**
	 * 가계부 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectLedgerList.ajax" )
	public List<WhiteMap> selectLedgerList(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);
		return ledgerService.selectLedgerList(param);		
	}
	
	
	/**
	 * 가게구 첫 입력날짜 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectFirstRecordDate.ajax")
	public WhiteMap selectFirstRecordDate(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		return ledgerService.selectFirstRecordDate(param);
	}
	
	/**
	 * 금전기록 수정 및 삭제
	 * @param request
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/ledger/applyRecordList.ajax")
	public WhiteMap applyRecordList(HttpServletRequest request) throws Exception {
		WhiteMap param = new WhiteMap(request);
		return ledgerService.applyRecordList(param);
	}
	
	/**
	 * 가게구 통계 데이터 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/ledger/selectLedgerStats.ajax")
	public WhiteMap selectLedgerStats(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		return ledgerService.selectLedgerStats(param);
	}
}
