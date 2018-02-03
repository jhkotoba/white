package com.ljh.white.common.constant;

import com.ljh.white.common.collection.WhiteSet;

public class TableColumns {

	//테이블 배열
	private final static String[] tables = {"authority", "money_record", "purpose", "user_bank", "white_user", "upper_purpose"};
	
	//컬럼 배열
	private final static String[] authority = 	{"authority_no","authority"};
	private final static String[] money_record = {"record_seq","group_seq","user_seq","record_date","content","purpose_seq","pur_detail_seq","bank_seq","move_to_seq","in_exp_money",
											"ready_money","bank_money","reg_date"};	
	private final static String[] purpose = {"purpose_seq","user_seq","pur_order","upper_pur_seq","purpose"};
	private final static String[] user_bank = {"bank_seq","user_seq","bank_name","bank_account","bank_now_use_yn"};
	private final static String[] white_user = {"user_seq","authority_no","user_id","user_name","user_passwd"};
	private final static String[] purpose_detail = {"pur_detail_seq","purpose_seq","user_seq", "pur_dtl_order","pur_detail"};
	
	public static String[] getTables() {
		return tables;
	}
	public static WhiteSet getTableSet(){
		return new WhiteSet(tables);
	}	
	
	public static String[] getAuthority() {
		return authority;
	}
	public static WhiteSet getAuthoritySet(){
		return new WhiteSet(authority);
	}	
	
	public static String[] getMoney_record() {
		return money_record;
	}
	public static WhiteSet getMoney_recordSet(){
		return new WhiteSet(money_record);
	}	
	
	public static String[] getPurpose() {
		return purpose;
	}
	public static WhiteSet getPurposeSet(){
		return new WhiteSet(purpose);
	}	
	
	public static String[] getUser_bank() {
		return user_bank;
	}
	public static WhiteSet getUser_bankSet(){
		return new WhiteSet(user_bank);
	}	
	
	public static String[] getWhite_user() {
		return white_user;
	}
	public static WhiteSet getWhite_userSet(){
		return new WhiteSet(white_user);
	}	
	
	public static String[] getPurpose_detail() {
		return purpose_detail;
	}
	public static WhiteSet getPurpose_detailSet(){
		return new WhiteSet(purpose_detail);
	}
	
	public static String[] isTable(String table){
		String[] string = null;
		switch(table){
		case "authority" : string = TableColumns.getAuthority();	break;
		case "money_record" : string = TableColumns.getMoney_record(); break;
		case "purpose" : string = TableColumns.getPurpose();	break;
		case "user_bank" : string = TableColumns.getUser_bank(); break;
		case "white_user" : string = TableColumns.getWhite_user(); break;		
		case "purpose_detail" : string = TableColumns.getPurpose_detail(); break;
		}
		return string;
	}
	
	public static WhiteSet isTableSet(String table){
		
		WhiteSet whiteSet = null;		
		switch(table){
		case "authority" : whiteSet = TableColumns.getAuthoritySet();	break;
		case "money_record" : whiteSet = TableColumns.getMoney_recordSet(); break;
		case "purpose" : whiteSet = TableColumns.getPurposeSet();	break;
		case "user_bank" : whiteSet = TableColumns.getUser_bankSet(); break;
		case "white_user" : whiteSet = TableColumns.getWhite_userSet(); break;		
		case "purpose_detail" : whiteSet = TableColumns.getPurpose_detailSet(); break;
		}
		return whiteSet;
	}
}
	         