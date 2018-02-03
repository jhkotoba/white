package com.ljh.white.login.service;

import com.ljh.white.common.bean.AuthBean;

public interface LoginService {
	
	//로그인 아이디체크
	public boolean loginUserCheck(String userId, String passwd);
	
	//해당 아이디로 권한 조회
	public AuthBean getUserAuthority(int userSeq);
	
	//유저 시퀀스 조회
	public int getUserSeq(String userId);
	
	//회원가입
	public int newSignUp(String userId, String userName, String passwd);
}
