package com.ljh.white.ledger.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.ledger.bean.MoneyRecordBean;
import com.ljh.white.ledger.bean.PurposeBean;
import com.ljh.white.ledger.bean.PurposeDetailBean;
import com.ljh.white.ledger.bean.BankBean;
import com.ljh.white.ledger.mapper.LedgerMapper;
import com.ljh.white.ledger.service.LedgerService;


import java.io.Serializable;
/**  리뉴얼로 대체
 * @author lee
 * @deprecated
 */
@Service("LedgerService")
public class LedgerServiceImpl implements LedgerService{
	

	
	@Resource(name = "LedgerMapper")
	private LedgerMapper ledgerMapper;
	

	


	
	// 가계부 내역 조회
	@Override
	public JSONObject getRecodeInquire(String userSeq, String startDate, String endDate, String purSeqSearch) {
		JSONArray userBankList = new JSONArray(ledgerMapper.getBankList(userSeq));
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("userSeq", userSeq);
		map.put("purSeqSearch", purSeqSearch);
		
		List<Map<String, Object>> moneyRecordList = ledgerMapper.getMoneyRecord(map);
				
		JSONObject jsonData = new JSONObject();
		jsonData.put("userBankList", userBankList);
		jsonData.put("moneyRecordList", moneyRecordList);
		
		return jsonData;	
	}
	
	// 최근 가계부 내역 조회
	@Override
	public JSONObject getLatestRecodeInquire(String userSeq) {	
		
		JSONArray userBankList = new JSONArray(ledgerMapper.getBankList(userSeq));
		
		List<Map<String, Object>> moneyRecordList = ledgerMapper.getLatestMoneyRecord(userSeq);		
		JSONObject jsonData = new JSONObject();
		jsonData.put("userBankList", userBankList);
		jsonData.put("moneyRecordList", moneyRecordList);
		
		return jsonData;	
	}
	
	// 출력된 목록 중에서 목록 마지막 값이 없을 때 조회된 아래값에 값 조회
	@Override
	public int serachLastRow(Map<String, String> map) {			
		Map<String, Object> moneyRecord = ledgerMapper.serachLastRow(map);		
		
		if(moneyRecord == null){
			return 0;
		}else{			
			if(map.get("bankAccount").equals("readyMoney")){				
				return Integer.parseInt(moneyRecord.get("readyMoney").toString());
			}else{	
				return Integer.parseInt(moneyRecord.get("resultBankMoney").toString());
			}
			
		}
	}
	
	// 사용 목적 받아오기
	@Override
	public JSONArray getPurposeList(String userSeq) {		
		List<PurposeBean> purposeList = ledgerMapper.getPurposeList(userSeq);		
		return new JSONArray(purposeList);
	}	
	@Override
	public JSONArray getPurposeDtlList(String userSeq) {		
		List<PurposeDetailBean> purposeDtlList = ledgerMapper.getPurposeDtlList(userSeq);		
		return new JSONArray(purposeDtlList);
	}	
	// 사용자 은행 목록 받아오기
	@Override
	public JSONArray getBankList(String userSeq) {			
		List<BankBean> getBankList = ledgerMapper.getBankList(userSeq);		
		return new JSONArray(getBankList);
	}
	
	// 사용자 현재 사용하는 은행 목록 받아오기
	@Override
	public JSONArray getUseBankList(String userSeq) {			
		List<Map<String, Object>> getBankList = ledgerMapper.getUseBankList(userSeq);		
		return new JSONArray(getBankList);
	}
	// 입력정보 insert
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int setInsertRecode(String insertData) throws ParseException {
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		JSONArray jsonArr = new JSONArray(insertData);
		JSONObject jsonObj = null;		
		
		for(int i=0; i<jsonArr.length(); i++){
			jsonObj = new JSONObject(jsonArr.get(i).toString());
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("userSeq", jsonObj.get("userSeq"));			
			map.put("recordDate", jsonObj.get("recordDate"));
			map.put("purposeSeq", jsonObj.get("purposeSeq"));
			map.put("purposeDtlSeq", jsonObj.get("purposeDtlSeq"));
			
			map.put("bankSeq", jsonObj.get("bankSeq"));
			
			map.put("moveToSeq", jsonObj.get("moveToSeq"));
			
			map.put("bankAccount", jsonObj.get("bankAccount"));
			map.put("inExpMoney", jsonObj.get("inExpMoney"));
			map.put("content", jsonObj.get("content"));
			map.put("updateType", "insert");
			
			list.add(map);
			map = null;
			jsonObj = null;			
		}		
		return ledgerMapper.setInsertRecode(list);
	}

	// recode 수정, 삭제
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int setEditDelRecode(String updateType, String editData) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		
		JSONArray jsonArr = new JSONArray(editData);
		JSONObject jsonObj = null;		
		
		for(int i=0; i<jsonArr.length(); i++){
			jsonObj = new JSONObject(jsonArr.get(i).toString());
			Map<String, Object> map = new HashMap<String, Object>();			
			
			map.put("userSeq", jsonObj.get("userSeq"));
			map.put("recordSeq", jsonObj.get("recordSeq"));
			map.put("recordDate", jsonObj.get("recordDate"));
			map.put("purposeSeq", jsonObj.get("purposeSeq"));
			map.put("purposeDtlSeq", jsonObj.get("purposeDtlSeq"));
			map.put("content", jsonObj.get("content"));
			map.put("bankSeq", jsonObj.get("bankSeq"));			
			map.put("updateType", updateType);
			
			if(updateType.equals("delete")){
				map.put("bankAccount", jsonObj.get("bankAccount"));	
				map.put("inExpMoney", jsonObj.get("inExpMoney"));
			}						
			
			list.add(map);
			map = null;
			jsonObj = null;			
		}
		
		if(updateType.equals("update")){
			return ledgerMapper.updateRecode(list);
		}else{
			return ledgerMapper.deleteRecode(list);
		}
		
	}
	
	//purpose 추가, 수정, 삭제
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public JSONArray setPurpose(String userSeq, String insert, String update, String delete){		
		
		JSONObject jsonObj = null;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();				
				
		//insert
		if(!insert.equals("")){
			JSONArray jsonArr = new JSONArray(insert);			
			
			for(int i=0; i<jsonArr.length(); i++){
				jsonObj = new JSONObject(jsonArr.get(i).toString());
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("userSeq", userSeq);
				map.put("purOrder", jsonObj.get("purOrder"));
				map.put("purpose", jsonObj.get("purpose"));
				list.add(map);	
			}			
			ledgerMapper.insertPurpose(list);			
			list.clear();
		}
		
		//update
		if(!update.equals("")){
			JSONArray jsonArr = new JSONArray(update);
			for(int i=0; i<jsonArr.length(); i++){
				jsonObj = new JSONObject(jsonArr.get(i).toString());			
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("userSeq", userSeq);
				map.put("purOrder", jsonObj.get("purOrder"));
				map.put("purpose", jsonObj.get("purpose"));
				map.put("purposeSeq", jsonObj.get("purposeSeq"));
				list.add(map);	
			}
			ledgerMapper.updetePurpose(list);
			list.clear();
		}
		
		//delete
		if(!delete.equals("")){
			JSONArray jsonArr = new JSONArray(delete);
			for(int i=0; i<jsonArr.length(); i++){
				jsonObj = new JSONObject(jsonArr.get(i).toString());			
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("userSeq", userSeq);
				map.put("purposeSeq", jsonObj.get("purposeSeq"));
				list.add(map);	
			}
			ledgerMapper.deletePurpose(list);
			list.clear();
		}
		
		return new JSONArray(ledgerMapper.getPurposeList(userSeq));	
	}
	
	
	//dtlPurpose 추가, 수정, 삭제
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public JSONArray setDtlPurpose(String userSeq, String insert, String update, String delete){		
		
		JSONObject jsonObj = null;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();				
				
		//insert
		if(!insert.equals("")){
			JSONArray jsonArr = new JSONArray(insert);			
			
			for(int i=0; i<jsonArr.length(); i++){
				jsonObj = new JSONObject(jsonArr.get(i).toString());
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("userSeq", userSeq);				
				map.put("purDtlOrder", 0);/*map.put("purDtlOrder", jsonObj.get("purDtlOrder"));*/ //사용안함 만들기 귀찮고 복잡해				
				map.put("purposeSeq", jsonObj.get("purposeSeq"));
				map.put("purDetail", jsonObj.get("purDetail"));
				list.add(map);	
			}			
			ledgerMapper.insertDtlPurpose(list);			
			list.clear();
		}
		
		//update
		if(!update.equals("")){
			JSONArray jsonArr = new JSONArray(update);
			for(int i=0; i<jsonArr.length(); i++){
				jsonObj = new JSONObject(jsonArr.get(i).toString());			
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("userSeq", userSeq);				
				map.put("purDtlOrder", 0);/*map.put("purDtlOrder", jsonObj.get("purDtlOrder"));*/ //사용안함 만들기 귀찮고 복잡해				
				map.put("purposeSeq", jsonObj.get("purposeSeq"));
				map.put("purDetail", jsonObj.get("purDetail"));
				map.put("purDetailSeq", jsonObj.get("purDetailSeq"));
				list.add(map);	
			}
			ledgerMapper.updeteDtlPurpose(list);
			list.clear();
		}
		
		//delete
		if(!delete.equals("")){
			JSONArray jsonArr = new JSONArray(delete);
			for(int i=0; i<jsonArr.length(); i++){
				jsonObj = new JSONObject(jsonArr.get(i).toString());			
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("userSeq", userSeq);
				map.put("purDetailSeq", jsonObj.get("purDetailSeq"));
				list.add(map);	
			}
			ledgerMapper.deleteDtlPurpose(list);
			list.clear();
		}
		
		return new JSONArray(ledgerMapper.getPurposeDtlList(userSeq));	
	}
	
	
	//Bank 추가, 수정, 삭제
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public JSONArray setBank(String userSeq, String insert, String update, String delete){		
		
		JSONObject jsonObj = null;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();				
				
		//insert
		if(!insert.equals("")){
			JSONArray jsonArr = new JSONArray(insert);			
			
			for(int i=0; i<jsonArr.length(); i++){
				jsonObj = new JSONObject(jsonArr.get(i).toString());
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("userSeq", userSeq);
				map.put("bankAccount", jsonObj.get("bankAccount"));
				map.put("bankName", jsonObj.get("bankName"));
				map.put("bankNowUseYN", jsonObj.get("bankNowUseYN"));				
				list.add(map);	
			}			
			ledgerMapper.insertBank(list);			
			list.clear();
		}
		
		//update
		if(!update.equals("")){
			JSONArray jsonArr = new JSONArray(update);
			for(int i=0; i<jsonArr.length(); i++){
				jsonObj = new JSONObject(jsonArr.get(i).toString());			
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("userSeq", userSeq);
				map.put("bankAccount", jsonObj.get("bankAccount"));
				map.put("bankName", jsonObj.get("bankName"));
				map.put("bankNowUseYN", jsonObj.get("bankNowUseYN"));
				map.put("bankSeq", jsonObj.get("bankSeq"));
				list.add(map);	
			}
			ledgerMapper.updateBank(list);
			list.clear();
		}
		
		//delete
		if(!delete.equals("")){
			JSONArray jsonArr = new JSONArray(delete);
			for(int i=0; i<jsonArr.length(); i++){
				jsonObj = new JSONObject(jsonArr.get(i).toString());			
				Map<String, Object> map = new HashMap<String, Object>();		
				
				map.put("userSeq", userSeq);
				map.put("bankSeq", jsonObj.get("bankSeq"));
				list.add(map);	
			}
			ledgerMapper.deleteBank(list);
			list.clear();
		}
		
		return new JSONArray(ledgerMapper.getUseBankList(userSeq));	
	}
	
	
	// 엑셀양식 다운로드 
	@Override
	public void excelStyleDown(HttpServletResponse response, WhiteMap whiteMap) throws IOException {		
		
		//다운로드 설정
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/octet-stream");		
		response.setHeader("content-disposition", "attachment;filename=insertExcel.xlsx;");		
		String path = whiteMap.getString("path")+"\\resources\\file\\insertExcel.xlsx";
				
		BufferedInputStream bis = new BufferedInputStream(new FileInputStream(path));
		BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
		
		int maxSize  = 10 * 1024 * 1024; //10mb
		
		byte[] buffer = new byte[maxSize];
		int length = 0;
		
		if((length = bis.read(buffer, 0, buffer.length)) != -1){
			bos.write(buffer, 0, length);		
		}
		if(bis != null) bis.close();
		if(bos != null) bos.close();
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public boolean ledgerExcelDataInit(WhiteMap whiteMap, MultipartFile file) throws Exception {
		System.out.println("ledgerExcelDataInit");
		
		short date = 0;		
		short content = 1;
		short account = 2;
		short money = 3;
		
		int startRow = 6;
		
		List<MoneyRecordBean> recordList = new ArrayList<MoneyRecordBean>();
		//Map<String, Object> purposeMap = 
		//Map<String, Object> userBankMap =
		
		Workbook workbook = WorkbookFactory.create(file.getInputStream());		
		Sheet sheet = workbook.getSheetAt(0);
		Row row = null;
		Cell cell = null;
		
		
		int endRow = sheet.getLastRowNum(); 
		
		for(int i=startRow; i<=endRow; i++){					
			
			row = sheet.getRow(i);	
			//System.out.println(row);
			System.out.print(row.getCell(date).getStringCellValue() + " | ");
			System.out.print(row.getCell(content).getStringCellValue() + " | ");
			System.out.print(new Double(row.getCell(account).getNumericCellValue()).toString() + " | ");
			System.out.println(row.getCell(money).getNumericCellValue());
				
			
			
			
			
			
			
		}
		
        
		
		
		
		 				
       
		
		
		
		
		
		return false;
	}
	
	//수정으로 사용불가
	/*@Override
	public void ledgerDataBackup(HttpServletResponse response, WhiteMap whiteMap) throws IOException {
		
		String userSeq = whiteMap.get("userSeq").toString();
		List<PurposeBean> purposeList = ledgerMapper.getPurposeList_backup(userSeq);//임시 나중에 동적쿼리로 합칠것
		List<UserBankBean> bankList = ledgerMapper.getBankList(userSeq);		
		List<MoneyRecordBean> recordList = ledgerMapper.selectAllMoneyRecord(userSeq);
		
		long time = System.currentTimeMillis();
		java.text.SimpleDateFormat dayTime = new java.text.SimpleDateFormat("yyyyMMdd_hhmmss");
		
		String fileName = Constant.LEDGER_FILE_NM.split("\\.")[0]
						+ "_" + whiteMap.getString("userId")
						+ "_" + dayTime.format(new java.util.Date(time))
						+ "." + Constant.LEDGER_FILE_NM.split("\\.")[1];
		
		//다운로드 설정
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/octet-stream");		
		response.setHeader("content-disposition", "attachment;filename="+fileName+";");	
				
		BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
		ObjectOutputStream oout = new ObjectOutputStream(bos);
		
		oout.writeObject(purposeList);
		oout.writeObject(bankList);
		oout.writeObject(recordList);
		if(oout!=null) oout.close();
		if(bos!=null) bos.close();
	}*/
	
	//수정으로 사용불가
	/*@Override
	@SuppressWarnings("unchecked")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public boolean ledgerDataInit(WhiteMap whiteMap, MultipartFile file) throws IOException {
		
		int userSeq = whiteMap.getInt("userSeq");		
		ObjectInputStream oins = new ObjectInputStream(file.getInputStream());
		
		ledgerMapper.deleteForInit(userSeq);
		 		
		List<PurposeBean> purposeOldList = new ArrayList<PurposeBean>();
		List<UserBankBean> bankOldList = new ArrayList<UserBankBean>();	
		List<MoneyRecordBean> recordBackupList = new ArrayList<MoneyRecordBean>();		
		try {
			purposeOldList = (List<PurposeBean>) oins.readObject();
			bankOldList = (List<UserBankBean>) oins.readObject();
			recordBackupList = (List<MoneyRecordBean>) oins.readObject();		
		} catch (ClassNotFoundException e) {
			//logger.error("");
			e.printStackTrace();
		}
		
		Map<Integer, Integer> purCheckMap = new HashMap<Integer, Integer>();
		
		if(!purposeOldList.isEmpty()){
			List<Integer> purOldSeqList = new ArrayList<Integer>();		
			//백업한 시퀀스
			for(int i=0; i<purposeOldList.size(); i++){
				purOldSeqList.add(purposeOldList.get(i).getPurposeSeq());
			}				
			//새로 insert 한 시퀀스
			List<Integer> purNewSeqList = ledgerMapper.insertBackupPurList(purposeOldList, userSeq);		
					
			for(int i=0; i<purOldSeqList.size(); i++){
				
				purCheckMap.put(purOldSeqList.get(i), purNewSeqList.get(i));
			}
		}
		
		
		///////////
		Map<Integer, Integer> bankCheckMap = new HashMap<Integer, Integer>();
		
		if(!bankOldList.isEmpty()){
			List<Integer> bankOldSeqList = new ArrayList<Integer>();
			//백업한 시퀀스
			for(int i=0; i<bankOldList.size(); i++){
				bankOldSeqList.add(bankOldList.get(i).getbankSeq());
			}
			//새로 insert 한 시퀀스
			List<Integer> bankNewSeqList = ledgerMapper.insertBackupBankList(bankOldList, userSeq);
			for(int i=0; i<bankOldSeqList.size(); i++){				
				bankCheckMap.put(bankOldSeqList.get(i), bankNewSeqList.get(i));
			}
		}
		
		
		
		System.out.println("purCheckMap: "+purCheckMap);
		System.out.println("bankCheckMap: "+bankCheckMap);
		System.out.println("recordBackupList: "+recordBackupList);
		
		int purOldSeq = 0;
		int bankOldSeq = 0;
		for(int i=0; i<recordBackupList.size(); i++){		
			
			recordBackupList.get(i).setUserSeq(userSeq);
			
			purOldSeq = recordBackupList.get(i).getPurposeSeq(); // -1 == 삭제된 목적
			if(purOldSeq == -1){
				recordBackupList.get(i).setPurposeSeq(-1);
			}else{
				recordBackupList.get(i).setPurposeSeq(purCheckMap.get(purOldSeq));
			}
			
			bankOldSeq = recordBackupList.get(i).getbankSeq(); // 0 현금 (디비에서 NULL이 MoneyRecordBean에서 bankSeq 자료형이 int 라 0으로 옴)
			if(bankOldSeq == 0){
				recordBackupList.get(i).setbankSeq(0);
			}else{
				recordBackupList.get(i).setbankSeq(bankCheckMap.get(bankOldSeq));
			}
			
		}
		System.out.println("recordBackupList: "+recordBackupList);
		
		ledgerMapper.insertBackupRecord(recordBackupList);
		
		//List<Integer> purSeqOldList = new ArrayList<Integer>(); 
		for(int i=0; i<purposeList.size(); i++){
			//System.out.println(purposeList.get(i).toString());
			//purSeqOldList.add(purposeList.get(i).getPurposeSeq());
			
		}
		for(int i=0; i<bankList.size(); i++){
			System.out.println(bankList.get(i).toString());
		}
		for(int i=0; i<recordList.size(); i++){
			System.out.println(recordList.get(i).toString());
		}
		
		
		if(oins!=null) oins.close();
		return false;
	}*/
}
