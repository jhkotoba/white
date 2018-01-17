package com.ljh.white.memo.bean;

import java.io.Serializable;

public class MemoBean implements Serializable{

	private static final long serialVersionUID = -472760618080812798L;
	
	private int memoSeq;
	private int userSeq;
	private String memoType;
	private String memoContent;
	private String regDate;
	
	public int getMemoSeq() {
		return memoSeq;
	}
	public void setMemoSeq(int memoSeq) {
		this.memoSeq = memoSeq;
	}
	public int getUserSeq() {
		return userSeq;
	}
	public void setUserSeq(int userSeq) {
		this.userSeq = userSeq;
	}
	public String getMemoType() {
		return memoType;
	}
	public void setMemoType(String memoType) {
		this.memoType = memoType;
	}
	public String getMemoContent() {
		return memoContent;
	}
	public void setMemoContent(String memoContent) {
		this.memoContent = memoContent;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	@Override
	public String toString() {
		return "MemoBean [memoSeq=" + memoSeq + ", userSeq=" + userSeq + ", memoType=" + memoType + ", memoContent="
				+ memoContent + ", regDate=" + regDate + "]";
	}
	
	
	
	
	
}
