package com.ljh.white.common.mapper;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;



@Repository("WhiteMapper")
public class WhiteMapper {
	
	private static Logger logger = LogManager.getLogger(WhiteMapper.class);
	
	@Autowired
	private SqlSession sqlSession;	
	
	public List<WhiteMap> selectSideMenuList(WhiteMap param){		
		logger.debug("param: "+param);
		return sqlSession.selectList("whiteMapper.selectSideMenuList", param);			
	}
	
	public List<WhiteMap> selectNavAuthList() {	
		return sqlSession.selectList("whiteMapper.selectNavAuthList");
	}
}
