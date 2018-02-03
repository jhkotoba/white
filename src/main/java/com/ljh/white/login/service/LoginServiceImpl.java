package com.ljh.white.login.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.common.bean.AuthBean;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.utility.cryptolect.BCrypt;
import com.ljh.white.common.vo.WhiteUesrVO;
import com.ljh.white.login.mapper.LoginMapper;
import com.ljh.white.login.service.LoginService;

@Service("LoginService")
public class LoginServiceImpl implements LoginService {	
	

	@Resource(name = "LoginMapper")
	private LoginMapper loginMapper;
	
	@Override
	public boolean loginUserCheck(String userId, String passwd){		
		WhiteUesrVO whiteUesrVO = new WhiteUesrVO();
		
		if(userId.toUpperCase().contains("SELECT"))
            return false;	
		
		whiteUesrVO.setUserId(userId);
		whiteUesrVO.setUserPasswd(passwd);
				
		return loginMapper.userCheck(whiteUesrVO);
	}

	@Override
	public AuthBean getUserAuthority(int userSeq) {				
		return new AuthBean(loginMapper.getUserAuthority(userSeq));
	}
	
	@Override
	public int getUserSeq(String userId) {
		return loginMapper.getUserSeq(userId);
	}

	@Override
	public int newSignUp(String userId, String userName,String passwd) {
		WhiteMap whiteMap = new WhiteMap();
		whiteMap.put("userId", userId);
		whiteMap.put("userName", userName);
		whiteMap.put("passwd", BCrypt.hashpw(passwd, BCrypt.gensalt()));
		return loginMapper.insertNewSignUp(whiteMap);		
	}

}
