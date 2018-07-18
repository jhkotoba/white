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
	public int selectSourceCount(WhiteMap param) {
		return sqlSession.selectOne("sourceMapper.selectSourceCount", param);
	}
	
	/**
	 * 소스게시판 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectSourceList(WhiteMap param) {
		return sqlSession.selectList("sourceMapper.selectSourceList", param);
	}
	
	/**
	 * 소스게시판 상세화면 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectSourceDtlView(WhiteMap param) {
		return sqlSession.selectOne("sourceMapper.selectSourceDtlView", param);
	}
	
	/**
	 * 소스게시판 새글 저장
	 * @param param
	 * @return
	 */
	public int insertSource(WhiteMap param) {
		return sqlSession.insert("sourceMapper.insertSource", param);
	}
	
	/**
	 * 소스게시판 글수정
	 * @param param
	 * @return
	 */
	public int updateSource(WhiteMap param) {
		return sqlSession.update("sourceMapper.updateSource", param);
	}
	
	/**
	 * 소스게시판 글삭제
	 * @param param
	 * @return
	 */
	public int deleteSource(WhiteMap param) {
		return sqlSession.update("sourceMapper.deleteSource", param);
	}
	
}
