package com.ljh.white.admin.mapper;


import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;

@Repository("AdminMapper")
public class AdminMapper {

	private static Logger logger = LogManager.getLogger(AdminMapper.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	public int selectUserCount(WhiteMap param) {
		logger.debug(param);		
		return sqlSession.selectOne("adminMapper.selectUserCount", param);
	}
	
	public List<WhiteMap> selectUserList(WhiteMap param) {
		logger.debug(param);		
		return sqlSession.selectList("adminMapper.selectUserList", param);
	}
	
	public List<WhiteMap> selectAuthList() {	
		return sqlSession.selectList("adminMapper.selectAuthList");
	}
	
	public List<WhiteMap> selectUserAuth(WhiteMap param) {
		logger.debug(param);		
		return sqlSession.selectList("adminMapper.selectUserAuth", param);
	}
}
