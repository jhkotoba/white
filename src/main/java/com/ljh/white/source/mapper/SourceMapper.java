package com.ljh.white.source.mapper;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.extend.CommonMapper;

@Repository("SourceMapper")
public class SourceMapper extends CommonMapper{
	
	/**
	 * 소스게시판 리스트 카운트
	 * @param param
	 * @return
	 */
	public int selectSourceCount(WhiteMap param) {
		return selectInt("sourceMapper.selectSourceCount", param);
	}
	
	/**
	 * 소스게시판 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectSourceList(WhiteMap param) {
		return selectList("sourceMapper.selectSourceList", param);
	}
	
	/**
	 * 소스게시판 상세화면 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectSourceDtlView(WhiteMap param) {
		return selectOne("sourceMapper.selectSourceDtlView", param);
	}
	
	/**
	 * 소스게시판 새글 저장
	 * @param param
	 * @return
	 */
	public int insertSource(WhiteMap param) {
		return insert("sourceMapper.insertSource", param);
	}
	
	/**
	 * 소스게시판 글수정
	 * @param param
	 * @return
	 */
	public int updateSource(WhiteMap param) {
		return update("sourceMapper.updateSource", param);
	}
	
	/**
	 * 소스게시판 글삭제
	 * @param param
	 * @return
	 */
	public int deleteSource(WhiteMap param) {
		return delete("sourceMapper.deleteSource", param);
	}	
}
