package com.ljh.white.ledger.service;

import java.io.IOException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.multipart.MultipartFile;

import com.ljh.white.common.collection.WhiteMap;
import java.io.Serializable;
/**  리뉴얼로 대체
 * @author lee
 * @deprecated
 */
public interface LedgerService {
			
	// 가계부 내역 조회
	public JSONObject getRecodeInquire(String userSeq, String startDate, String endDate, String purSeqSearch);
	
	// 최근 가계부 내역 조회
	public JSONObject getLatestRecodeInquire(String userSeq);
	
	// 출력된 목록 중에서 목록 마지막 값이 없을 때 조회된 아래값에 값 조회
	public int serachLastRow(Map<String, String> map);	
	
	//사용 목적 받아오기
	public JSONArray getPurposeList(String userSeq);
	public JSONArray getPurposeDtlList(String userSeq);
	
	//사용자 은행 목록 받아오기
	public JSONArray getBankList(String userSeq);
	
	//사용자 현재 사용하는 은행 목록 받아오기
	public JSONArray getUseBankList(String userSeq);
	
	//입력 정보 insert
	public int setInsertRecode(String insertData) throws ParseException;
	
	//데이터 수정/삭제
	public int setEditDelRecode(String type, String editData);
	
	//사용목적 추가, 수정, 삭제  / 리턴 사용목적 조회
	public JSONArray setPurpose(String userSeq, String insert, String update, String delete);
	
	//상세사용목적 추가, 수정, 삭제  / 리턴 사용목적 조회
	public JSONArray setDtlPurpose(String userSeq, String insert, String update, String delete);
	
	//은행 추가, 수정, 삭제  / 리턴 사용목적 조회
	public JSONArray setBank(String userSeq, String insert, String update, String delete);
	
	/** 엑셀양식 다운로드  */ 
	public void excelStyleDown(HttpServletResponse response, WhiteMap whiteMap) throws IOException;
	
	
	/** 수정으로 인해 사용불가
	 * 가계부 관련된 DB중 purpose, userBank, moneyRocord 컬럼의 데이터를 조회를 하여 
	 * TXT 파일로 생성 후 다운로드 하는 메소드
	 */
	//public void ledgerDataBackup(HttpServletResponse response, WhiteMap whiteMap) throws IOException;
	
	/**수정으로 인해 사용불가
	 * 가계부 관련된 DB중 purpose, userBank, moneyRocord 컬럼의 데이터의 백업파일을 업로드하여
	 * 위 3개 테이블을 초기화
	 */
	//public boolean ledgerDataInit(WhiteMap whiteMap, MultipartFile file)throws IOException;
	
	public boolean ledgerExcelDataInit(WhiteMap whiteMap, MultipartFile file)throws Exception;
	

}
