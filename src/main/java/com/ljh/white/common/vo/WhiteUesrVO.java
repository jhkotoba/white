package com.ljh.white.common.vo;

import java.sql.Timestamp;

public class WhiteUesrVO {
	
	private int uesrSeq;
	private String authoriyNo;
	private String userId;
	private String userName;
	private String userPasswd;
	private int userMoney;
	private Timestamp userLastAccessTime;
	public int getUserSeq() {
		return uesrSeq;
	}
	public void setUserNo(int uesrSeq) {
		this.uesrSeq = uesrSeq;
	}
	public String getAuthoriyNo() {
		return authoriyNo;
	}
	public void setAuthoriyNo(String authoriyNo) {
		this.authoriyNo = authoriyNo;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserPasswd() {
		return userPasswd;
	}
	public void setUserPasswd(String userPasswd) {
		this.userPasswd = userPasswd;
	}
	public int getUserMoney() {
		return userMoney;
	}
	public void setUserMoney(int userMoney) {
		this.userMoney = userMoney;
	}
	public Timestamp getUserLastAccessTime() {
		return userLastAccessTime;
	}
	public void setUserLastAccessTime(Timestamp userLastAccessTime) {
		this.userLastAccessTime = userLastAccessTime;
	}
	@Override
	public String toString() {
		return "WhiteUesrVO [uesrSeq=" + uesrSeq + ", authoriyNo=" + authoriyNo + ", userId=" + userId + ", userName="
				+ userName + ", userPasswd=" + userPasswd + ", userMoney=" + userMoney + ", userLastAccessTime="
				+ userLastAccessTime + "]";
	}
	
	
	
	
	
}
