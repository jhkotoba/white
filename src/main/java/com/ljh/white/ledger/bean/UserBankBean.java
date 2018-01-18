package com.ljh.white.ledger.bean;

import java.io.Serializable;

public class UserBankBean implements Serializable{

	
	private static final long serialVersionUID = 1775481562298901988L;	

	private int userBankSeq;
	private int userSeq;
	private String bankName;
	private String bankAccount;
	private String bankNowUseYN;
	public int getUserBankSeq() {
		return userBankSeq;
	}
	public void setUserBankSeq(int userBankSeq) {
		this.userBankSeq = userBankSeq;
	}
	public int getUserSeq() {
		return userSeq;
	}
	public void setUserSeq(int userSeq) {
		this.userSeq = userSeq;
	}
	public String getBankName() {
		return bankName;
	}
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	public String getBankAccount() {
		return bankAccount;
	}
	public void setBankAccount(String bankAccount) {
		this.bankAccount = bankAccount;
	}
	public String getBankNowUseYN() {
		return bankNowUseYN;
	}
	public void setBankNowUseYN(String bankNowUseYN) {
		this.bankNowUseYN = bankNowUseYN;
	}
	
	@Override
	public String toString() {
		return "UserBankBean [userBankSeq=" + userBankSeq + ", userSeq=" + userSeq + ", bankName=" + bankName
				+ ", bankAccount=" + bankAccount + ", bankNowUseYN=" + bankNowUseYN + "]";
	}	

	
}
