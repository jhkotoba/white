package com.ljh.white.login.service;

import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.utility.cryptolect.BCrypt;
import com.ljh.white.common.vo.WhiteUesrVO;
import com.ljh.white.login.mapper.LoginMapper;
import com.ljh.white.login.service.LoginService;

@Service("LoginService")
public class LoginServiceImpl implements LoginService {
	
	private static Logger logger = LogManager.getLogger(LoginServiceImpl.class);

	@Resource(name = "LoginMapper")
	private LoginMapper loginMapper;
	
	@Override
	public boolean loginUserCheck(String userId, String passwd){
		logger.info("");
		logger.debug("userId: "+userId + ", passwd:"+passwd);		
		
		WhiteUesrVO whiteUesrVO = new WhiteUesrVO();
		
		if(userId.toUpperCase().contains("SELECT"))
            return false;	
		
		whiteUesrVO.setUserId(userId);
		whiteUesrVO.setUserPasswd(passwd);
				
		return loginMapper.userCheck(whiteUesrVO);
	}

	@Override
	public Map<String, Object> getUserAuthority(String userId) {
		logger.info("");
		logger.debug("userId: "+userId);
		
		return loginMapper.getUserAuthority(userId);
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
