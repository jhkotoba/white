package com.ljh.white.login.mapper;


import java.util.List;

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
		
		String userPasswd = sqlSession.selectOne("LoginMapper.userCheck", whiteUesrVO);		
		
		return userPasswd == null ? false : BCrypt.checkpw(whiteUesrVO.getUserPasswd(), userPasswd);		
	}	 
	
	public List<WhiteMap> selectUserAuthority(int userSeq){		
		logger.debug("userSeq: "+userSeq);
		return sqlSession.selectList("LoginMapper.selectUserAuthority", userSeq);			
	}
	
	public List<WhiteMap> selectNavMenuList(WhiteMap param){		
		logger.debug("param: "+param);
		return sqlSession.selectList("LoginMapper.selectNavMenuList", param);			
	}
	
	public List<WhiteMap> selectSideMenuList(WhiteMap param){		
		logger.debug("param: "+param);
		return sqlSession.selectList("LoginMapper.selectSideMenuList", param);			
	}
	
	public int getUserSeq(String userId){
		return sqlSession.selectOne("LoginMapper.getUserSeq", userId);			
	}
	
	public int userIdCheck(String userId){
		return sqlSession.selectOne("LoginMapper.userIdCheck", userId);	
	}
	
	public int insertSignUp(WhiteMap param){
		logger.debug("whiteMap: "+param);	
		
		int rtn = sqlSession.insert("LoginMapper.insertSignUp", param);
		sqlSession.insert("LoginMapper.insertUserAuth", param.getString("user_seq"));	
		
		return rtn;
		
		//test user Insert
		/*String id = param.getString("userId");
		for(int i=0; i<300; i++) {
			param.put("userId",id+i);
			int rtn = sqlSession.insert("LoginMapper.insertSignUp", param);
			sqlSession.insert("LoginMapper.insertUserAuth", param.getString("user_seq"));
			param.remove("user_seq");
		}		
		return 0;*/
	}
}
