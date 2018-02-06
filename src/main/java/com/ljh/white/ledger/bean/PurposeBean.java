package com.ljh.white.ledger.bean;

import java.io.Serializable;
import java.io.Serializable;
/**  리뉴얼로 대체
 * @author lee
 * @deprecated
 */
public class PurposeBean implements Serializable{
	
	private static final long serialVersionUID = 2521975016873285653L;
	
	private int purSeq;
	private int userSeq;
	private int purOrder;
	private String purpose;	

	public int getPurSeq() {
		return purSeq;
	}
	public void setPurSeq(int purSeq) {
		this.purSeq = purSeq;
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
		return "PurposeBean [purSeq=" + purSeq + ", userSeq=" + userSeq + ", purOrder=" + purOrder
				+ ", purpose=" + purpose + "]";
	}

	
}