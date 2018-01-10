package com.ljh.white.common.bean;

import java.io.Serializable;

public class PurposeBean implements Serializable{
	
	private static final long serialVersionUID = 2521975016873285653L;
	
	private int purposeSeq;
	private int userSeq;
	private int purOrder;
	private String purpose;	

	public int getPurposeSeq() {
		return purposeSeq;
	}
	public void setPurposeSeq(int purposeSeq) {
		this.purposeSeq = purposeSeq;
	}
	public int getUserSeq() {
		return userSeq;
	}
	public void setUserSeq(int userSeq) {
		this.userSeq = userSeq;
	}
	public int getPurOrder() {
		return purOrder;
	}
	public void setPurOrder(int purOrder) {
		this.purOrder = purOrder;
	}
	public String getPurpose() {
		return purpose;
	}
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	@Override
	public String toString() {
		return "PurposeBean [purposeSeq=" + purposeSeq + ", userSeq=" + userSeq + ", purOrder=" + purOrder
				+ ", purpose=" + purpose + "]";
	}

	
}