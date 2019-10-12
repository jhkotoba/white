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

	public List<WhiteMap> selectUpperMenuList(WhiteMap param){
		return sqlSession.selectList("mainMapper.selectUpperMenuList", param);			
	}
	
	public List<WhiteMap> selectLowerMenuList(WhiteMap param){	
		return sqlSession.selectList("mainMapper.selectLowerMenuList", param);			
	}
}
