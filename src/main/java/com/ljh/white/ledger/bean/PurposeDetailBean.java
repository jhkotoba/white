package com.ljh.white.ledger.bean;

import java.io.Serializable;
import java.io.Serializable;
/**  리뉴얼로 대체
 * @author lee
 * @deprecated
 */
public class PurposeDetailBean implements Serializable{
	
	private static final long serialVersionUID = 2521975016873285653L;
	
	private int purDetailSeq;
	private int purSeq;
	private int userSeq;
	private int purDtlOrder;
	private String purDetail;
	
	public int getPurDetailSeq() {
		return purDetailSeq;
	}
	public void setPurDetailSeq(int purDetailSeq) {
		this.purDetailSeq = purDetailSeq;
	}
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
	public int getPurDtlOrder() {
		return purDtlOrder;
	}
	public void setPurDtlOrder(int purDtlOrder) {
		this.purDtlOrder = purDtlOrder;
	}
	public String getPurDetail() {
		return purDetail;
	}
	public void setPurDetail(String purDetail) {
		this.purDetail = purDetail;
	}	
	@Override
	public String toString() {
		return "PurposeDetailBean [purDetailSeq=" + purDetailSeq + ", purSeq=" + purSeq + ", userSeq=" + userSeq
				+ ", purDtlOrder=" + purDtlOrder + ", purDetail=" + purDetail + "]";
	}
	
	
	

	
}