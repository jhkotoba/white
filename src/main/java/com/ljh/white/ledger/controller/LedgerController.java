package com.ljh.white.ledger.controller;

import java.io.IOException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.ljh.white.common.Constant;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.ledger.service.LedgerService;

@Controller
public class LedgerController {
	
	@Resource(name = "LedgerService")
	private LedgerService ledgerService;
	
	private static Logger logger = LogManager.getLogger(LedgerController.class);
	
	//ledgerPage 가계부 분기 페이지
	@RequestMapping(value="/ledgerPage.do" )
	public String ledgerPage(HttpServletRequest request){		
		logger.debug("LedgerSide: "+ request.getParameter("sideClick") + " Page");
		
		String sectionPage = request.getParameter("sideClick");		
		String userSeq = request.getSession(false).getAttribute("userSeq").toString();
		
		if(sectionPage == null) sectionPage = "Main";		
		
		switch(sectionPage){
		case "Select" :			
		case "Insert" :
			request.setAttribute("purposeList", ledgerService.getPurposeList(userSeq));	
			request.setAttribute("purposeDtlList", ledgerService.getPurposeDtlList(userSeq));
			request.setAttribute("userBankList", ledgerService.getUseBankList(userSeq));			
			break;
		case "SetupPurpose" :
			request.setAttribute("purposeList", ledgerService.getPurposeList(userSeq));			
			request.setAttribute("purposeDtlList", ledgerService.getPurposeDtlList(userSeq));
			break;
		case "SetupBank" :
			request.setAttribute("bankList", ledgerService.getUseBankList(userSeq));
			break;
		case "FileInOut" :			
			break;
		}
			
		//page	
		request.setAttribute("sidePage", "ledger/ledgerSide.jsp");		
		request.setAttribute("sectionPage", "ledger/ledger"+sectionPage+".jsp");		
		
		return "white.jsp";		
	}
	
	/** 엑셀양식 다운로드  */ 
	@RequestMapping(value="/excelStyleDown.do")
	public void excelStyleDown(HttpServletRequest request, HttpServletResponse response) throws IOException{
		
		WhiteMap whiteMap = new WhiteMap(request);
		 
		
		ledgerService.excelStyleDown(response, whiteMap);
	}
	
	//미사용
	/** purpose, userBank , moneyRocord 테이블 백업 데이터 다운로드  *//*	 
	@RequestMapping(value="/ledgerDataBackup.do")
	public void ledgerDataDownload(HttpServletRequest request, HttpServletResponse response) throws IOException{
		WhiteMap whiteMap = new WhiteMap(request);
		ledgerService.ledgerDataBackup(response, whiteMap);
	}	
	*//** 백업파일로 업로드하여  purpose, userBank , moneyRocord 테이블 백얼파일로 초기화 *//*
	@RequestMapping(value="/ajax/ledgerDataInit.do", method = RequestMethod.POST, headers = ("content-type=multipart/*"))
	public String ledgerDataInit (HttpServletRequest request, MultipartFile file) throws IOException, ServletException{
		WhiteMap whiteMap = new WhiteMap(request);
		ledgerService.ledgerDataInit(whiteMap, file);
		
    	return "result.jsp";
	}
	*//** purpose, userBank , moneyRocord 삭제 *//*	 
	@RequestMapping(value="/ledgerDataDelete.do")
	public void ledgerDataDelete(HttpServletRequest request) throws IOException{
		//WhiteMap whiteMap = new WhiteMap(request);
	}*/
	
	/***** Ajax *****/
	
	//가계부 조회
	@RequestMapping(value="/ajax/ledgerInquire.do")
	public String ledgerInquire(HttpServletRequest request){
		
		String userSeq = request.getSession(false).getAttribute("userSeq").toString();
		String startDate = request.getParameter("startDate") + " 00:00:00";
		String endDate = request.getParameter("endDate") + " 23:59:59";
		String purSeqSearch = request.getParameter("purSeqSearch");

		
		JSONObject result = ledgerService.getRecodeInquire(userSeq, startDate, endDate, purSeqSearch);		
		request.setAttribute("result", result);
		
		return "result.jsp";
	}
	//최근 가계부 조회
	@RequestMapping(value="/ajax/latestLedgerInquire.do")
	public String latestLedgerInquire(HttpServletRequest request){	
		
		String userSeq = request.getSession(false).getAttribute("userSeq").toString();
		JSONObject result = ledgerService.getLatestRecodeInquire(userSeq);
		
		request.setAttribute("result", result);
		
		return "result.jsp";
	}
	// 가계부 조회 - 조회시 마지막 행 구하기
	@RequestMapping(value="/ajax/ledgerEmpAdd.do")
	public String ledgerEmpAdd(HttpServletRequest request){	
			
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("userSeq", request.getSession(false).getAttribute("userSeq").toString());
		/*map.put("recordSeq", request.getParameter("recordSeq")); 사용안하는거 같음*/
		map.put("bankAccount", request.getParameter("bankAccount"));
		map.put("userBankSeq", request.getParameter("userBankSeq"));
		map.put("recordDate", request.getParameter("recordDate"));		
		
		Integer result = ledgerService.serachLastRow(map);		
		
		request.setAttribute("result", result.toString());
		return "result.jsp";
	}
	//데이터 입력
	@RequestMapping(value="/ajax/ledgerInsert.do")
	public String ledgerInsert(HttpServletRequest request) throws ParseException{		
		
		String insertData = request.getParameter("insertData");		
		int insertCnt = ledgerService.setInsertRecode(insertData);
		request.setAttribute("result", insertCnt);
		
		return "result.jsp";
	}
	
	//데이터 수정,삭제
	@RequestMapping(value="/ajax/ledgerEditDel.do")
	public String ledgerEditDel(HttpServletRequest request){		
		
		String editData = request.getParameter("editData");
		String updateType = request.getParameter("updateType");
		
		int editCnt = ledgerService.setEditDelRecode(updateType, editData);
		request.setAttribute("result", editCnt);
		
		return "result.jsp";
	}
	
	//목적 추가, 수정, 삭제
	@RequestMapping(value="/ajax/ledgerSetupPurpose.do")
	public String ledgerSetupPurpose(HttpServletRequest request){	
		
		String userSeq = request.getSession(false).getAttribute("userSeq").toString();
		String insert = request.getParameter("insertList");
		String update = request.getParameter("updateList");		
		String delete = request.getParameter("deleteList");		
		
		JSONArray purpose = ledgerService.setPurpose(userSeq, insert, update, delete);
				
		request.setAttribute("result", purpose);
		
		return "result.jsp";
	}
	
	//상세목적 추가, 수정, 삭제
	@RequestMapping(value="/ajax/ledgerSetupDtlPurpose.do")
	public String ledgerSetupDtlPurpose(HttpServletRequest request){	
		
		String userSeq = request.getSession(false).getAttribute("userSeq").toString();
		String insert = request.getParameter("insertDtlList");
		String update = request.getParameter("updateDtlList");		
		String delete = request.getParameter("deleteDtlList");		
		
		JSONArray dtlPurpose = ledgerService.setDtlPurpose(userSeq, insert, update, delete);
				
		request.setAttribute("result", dtlPurpose);
		
		return "result.jsp";
	}
	
	//은행 추가, 수정, 삭제
	@RequestMapping(value="/ajax/ledgerSetupBank.do")
	public String ledgerSetupBank(HttpServletRequest request){	
		
		String userSeq = request.getSession(false).getAttribute("userSeq").toString();
		String insert = request.getParameter("insertList");
		String update = request.getParameter("updateList");		
		String delete = request.getParameter("deleteList");		
		
		JSONArray purpose = ledgerService.setBank(userSeq, insert, update, delete);
				
		request.setAttribute("result", purpose);
		
		return "result.jsp";
	}	
	
	//insert record excel upload
	@RequestMapping(value="/ajax/insertExcelUpload.do", method = RequestMethod.POST, headers = ("content-type=multipart/*"))
	public String insertExcelUpload (HttpServletRequest request, MultipartFile file) throws Exception{
		WhiteMap whiteMap = new WhiteMap(request);
		
		ledgerService.ledgerExcelDataInit(whiteMap, file);
		
    	return "result.jsp";
	

	}	
	
}
