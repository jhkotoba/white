package com.ljh.white.ledger.bean;

import java.io.Serializable;

public class MoneyRecordBean implements Serializable{

	
	private static final long serialVersionUID = -5497073342354634710L;

	private int recordSeq;
	private int groupSeq;
	private int userSeq;
	private String recordDate;
	private String content;
	private int purposeSeq;
	private int userBankSeq;
	private int moveToSeq;
	private int inExpMoney;
	private int readyMoney;
	private int resultBankMoney;
	private String regDate;
	public int getRecordSeq() {
		return recordSeq;
	}
	public void setRecordSeq(int recordSeq) {
		this.recordSeq = recordSeq;
	}
	public int getGroupSeq() {
		return groupSeq;
	}
	public void setGroupSeq(int groupSeq) {
		this.groupSeq = groupSeq;
	}
	public int getUserSeq() {
		return userSeq;
	}
	public void setUserSeq(int userSeq) {
		this.userSeq = userSeq;
	}
	public String getRecordDate() {
		return recordDate;
	}
	public void setRecordDate(String recordDate) {
		this.recordDate = recordDate;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getPurposeSeq() {
		return purposeSeq;
	}
	public void setPurposeSeq(int purposeSeq) {
		this.purposeSeq = purposeSeq;
	}
	public int getUserBankSeq() {
		return userBankSeq;
	}
	public void setUserBankSeq(int userBankSeq) {
		this.userBankSeq = userBankSeq;
	}
	public int getMoveToSeq() {
		return moveToSeq;
	}
	public void setMoveToSeq(int moveToSeq) {
		this.moveToSeq = moveToSeq;
	}
	public int getInExpMoney() {
		return inExpMoney;
	}
	public void setInExpMoney(int inExpMoney) {
		this.inExpMoney = inExpMoney;
	}
	public int getReadyMoney() {
		return readyMoney;
	}
	public void setReadyMoney(int readyMoney) {
		this.readyMoney = readyMoney;
	}
	public int getResultBankMoney() {
		return resultBankMoney;
	}
	public void setResultBankMoney(int resultBankMoney) {
		this.resultBankMoney = resultBankMoney;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	@Override
	public String toString() {
		return "MoneyRecordBean [recordSeq=" + recordSeq + ", groupSeq=" + groupSeq + ", userSeq=" + userSeq
				+ ", recordDate=" + recordDate + ", content=" + content + ", purposeSeq=" + purposeSeq
				+ ", userBankSeq=" + userBankSeq + ", moveToSeq=" + moveToSeq + ", inExpMoney=" + inExpMoney
				+ ", readyMoney=" + readyMoney + ", resultBankMoney=" + resultBankMoney + ", regDate=" + regDate + "]";
	}
	 	
	
	
}
