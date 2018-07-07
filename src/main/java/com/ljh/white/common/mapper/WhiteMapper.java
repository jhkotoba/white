package com.ljh.white.common.mapper;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;



@Repository("WhiteMapper")
public class WhiteMapper {
	
	@Autowired
	private SqlSession sqlSession;	
	
	public List<WhiteMap> selectNavAuthList() {	
		return sqlSession.selectList("whiteMapper.selectNavAuthList");
	}
	
	public List<WhiteMap> selectSideAuthList() {	
		return sqlSession.selectList("whiteMapper.selectSideAuthList");
	}
	
	/**
	 * 코드리스트 SELECT
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectCodeList(WhiteMap param) {	
		return sqlSession.selectList("whiteMapper.selectCodeList", param);
	}
}
