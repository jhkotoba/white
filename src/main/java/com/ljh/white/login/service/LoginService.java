package com.ljh.white.login.service;

import java.util.Map;

public interface LoginService {
	
	//로그인 아이디체크
	public boolean loginUserCheck(String userId, String passwd);
	
	//해당 아이디로 권한 조회
	public Map<String, Object> getUserAuthority(String userId);
	
	//회원가입
	public int newSignUp(String userId, String userName, String passwd);
}
