package com.ljh.white.login.mapper;


import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.utility.cryptolect.BCrypt;
import com.ljh.white.common.vo.WhiteUesrVO;


@Repository("LoginMapper")
public class LoginMapper {
	
	private static Logger logger = LogManager.getLogger(LoginMapper.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	public boolean userCheck(WhiteUesrVO whiteUesrVO){		
		logger.debug("WhiteUesrVO: "+whiteUesrVO);
		
		// null 체크
		if(whiteUesrVO.getUserId() == null || whiteUesrVO.getUserPasswd() == null){
			logger.warn("whiteUesrVO.userId:" +whiteUesrVO.getUserId()+ ", whiteUesrVO.userPasswd:"+whiteUesrVO.getUserPasswd());
			return false;
		}
		
		String userPasswd = sqlSession.selectOne("com.ljh.white.login.service.LoginMapper.userCheck", whiteUesrVO);		
		
		return userPasswd == null ? false : BCrypt.checkpw(whiteUesrVO.getUserPasswd(), userPasswd);		
	}
	
	public Map<String, Object> getUserAuthority(String userId){		
		logger.debug("userId: "+userId);		
		
		return sqlSession.selectOne("com.ljh.white.login.service.LoginMapper.getUserAuthority", userId);			
	}
	
	public int insertNewSignUp(WhiteMap whiteMap){
		logger.debug("whiteMap: "+whiteMap);	
		return sqlSession.insert("com.ljh.white.login.service.LoginMapper.insertNewSignUp", whiteMap);		
	}
}
