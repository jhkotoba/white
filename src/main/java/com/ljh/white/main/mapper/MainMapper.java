package com.ljh.white.main.mapper;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;

@Repository("MainMapper")
public class MainMapper {
	
	@Autowired
	private SqlSession sqlSession;
	
	public String selectUserPasswd(WhiteMap param) {
		return sqlSession.selectOne("mainMapper.selectUserPasswd", param);
	}
	
	public int getUserSeq(String userId){
		return sqlSession.selectOne("mainMapper.getUserSeq", userId);			
	}
	
	public List<WhiteMap> selectUserAuthority(int userSeq){		
		return sqlSession.selectList("mainMapper.selectUserAuthority", userSeq);			
	}

	public List<WhiteMap> selectNavMenuList(WhiteMap param){
		return sqlSession.selectList("mainMapper.selectNavMenuList", param);			
	}
	
	public List<WhiteMap> selectSideMenuList(WhiteMap param){	
		return sqlSession.selectList("mainMapper.selectSideMenuList", param);			
	}
}
