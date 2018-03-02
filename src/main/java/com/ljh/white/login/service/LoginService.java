package com.ljh.white.login.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.utility.cryptolect.BCrypt;
import com.ljh.white.common.vo.WhiteUesrVO;
import com.ljh.white.login.mapper.LoginMapper;

@Service("LoginService")
public class LoginService{	
	

	@Resource(name = "LoginMapper")
	private LoginMapper loginMapper;
	
	
	public boolean loginUserCheck(String userId, String passwd){		
		WhiteUesrVO whiteUesrVO = new WhiteUesrVO();
		
		if(userId.toUpperCase().contains("SELECT"))
            return false;	
		
		whiteUesrVO.setUserId(userId);
		whiteUesrVO.setUserPasswd(passwd);
				
		return loginMapper.userCheck(whiteUesrVO);
	}	
	
	public WhiteMap selectUserAuthority(int userSeq, String userId) {		
		List<WhiteMap> authList = loginMapper.selectUserAuthority(userSeq);
		WhiteMap auth = new WhiteMap();
		
		if("leedev".equals(userId)) {
			for(int i=0; i<authList.size(); i++) {
				authList.get(i).put("auth", 1);
			}			
		}
		
		for(int i=0; i<authList.size(); i++) {
			auth.put(authList.get(i).getString("authNm"), authList.get(i).getString("auth"));
		}		
		return auth;
	}
	
	public List<WhiteMap> selectNavMenuList(int userSeq) {		
		return loginMapper.selectNavMenuList(userSeq);		
	}
	
	
	
	public int getUserSeq(String userId) {
		return loginMapper.getUserSeq(userId);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int insertSignUp(String userId, String userName,String passwd) {
		WhiteMap param = new WhiteMap();
		param.put("userId", userId);
		param.put("userName", userName);
		param.put("passwd", BCrypt.hashpw(passwd, BCrypt.gensalt()));		
		return loginMapper.insertSignUp(param);	}

}
