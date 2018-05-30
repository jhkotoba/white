package com.ljh.white.source.mapper;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;

@Repository("SourceMapper")
public class SourceMapper {
	
	@Autowired
	private SqlSession sqlSession;

	public List<WhiteMap> selectSourceCodeList(WhiteMap param) {
		return sqlSession.selectList("sourceMapper.selectSourceCodeList", param);		
	}
	
}
