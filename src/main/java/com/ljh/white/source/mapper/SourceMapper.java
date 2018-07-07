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
	
	/**
	 * 소스게시판 리스트 카운트
	 * @param param
	 * @return
	 */
	public int selectSourceCodeCount(WhiteMap param) {
		return sqlSession.selectOne("sourceMapper.selectSourceCodeCount", param);
	}
	
	/**
	 * 소스게시판 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectSourceCodeList(WhiteMap param) {
		return sqlSession.selectList("sourceMapper.selectSourceCodeList", param);
	}
	
	/**
	 * 소스게시판 상세화면 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectSourceDtlView(WhiteMap param) {
		return sqlSession.selectOne("sourceMapper.selectSourceDtlView", param);
	}
	
}
