package com.ljh.white.common.extend;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import com.ljh.white.common.collection.WhiteMap;

public class CommonMapper {
	
	@Autowired
	private SqlSession sqlSession;
	
	public int selectInt(String statement, Object parameter){
		return sqlSession.selectOne(statement, parameter);
	}
	
	public WhiteMap selectOne(String statement, Object parameter){	
		return this.converterCamelCase((WhiteMap)sqlSession.selectOne(statement, parameter));
	}
	
	public List<WhiteMap> selectList(String statement, Object parameter){
		List<WhiteMap> list = sqlSession.selectList(statement, parameter);
		return this.converterCamelCase(list);
	}
	
	public int insert(String statement) {
		return sqlSession.insert(statement, null);
	}
	
	public int insert(String statement, Object parameter) {
		return sqlSession.insert(statement, parameter);
	}
	
	public int update(String statement) {
		return sqlSession.update(statement, null);
	}
	
	public int update(String statement, Object parameter) {
		return sqlSession.update(statement, parameter);
	}
	
	public int delete(String statement) {
		return sqlSession.delete(statement, null);
	}
	
	public int delete(String statement, Object parameter) {
		return sqlSession.delete(statement, parameter);
	}
	
	
	private List<WhiteMap> converterCamelCase(List<WhiteMap> list){
		return list;
	}
	
	private WhiteMap converterCamelCase(WhiteMap param){
		return param;
	}
	
	
}
