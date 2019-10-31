package com.ljh.white.source.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.source.mapper.SourceMapper;
import com.ljh.white.white.mapper.WhiteMapper;

@Service("SourceService")
public class SourceService {
	
	@Resource(name = "SourceMapper")
	private SourceMapper sourceMapper;
	
	@Resource(name = "WhiteMapper")
	private WhiteMapper whiteMapper;
	
	/**
	 * 소스게시판 리스트 카운트
	 * @param param
	 * @return
	 */
	public int selectSourceCount(WhiteMap param) {
		return sourceMapper.selectSourceCount(param);	
	}
	
	/**
	 * 소스게시판 리스트 조회
	 * @param Parma
	 * @return
	 */
	public List<WhiteMap> selectSourceList(WhiteMap param){
		param.put("pagePre", (param.getInt("pageIndex")-1)*param.getInt("pageSize"));
		return sourceMapper.selectSourceList(param);
	}
	
	/**
	 * 소스게시판 상세화면 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectSourceDtlView(WhiteMap param) {		
		return sourceMapper.selectSourceDtlView(param);	
		
	}
	
	/**
	 * 소스게시판 새글 저장
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int insertSource(WhiteMap param) {
		return sourceMapper.insertSource(param);
	}
	
	/**
	 * 소스게시판 글수정
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateSource(WhiteMap param) {		
		return sourceMapper.updateSource(param);
	}
	
	/**
	 * 소스게시판 글삭제
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteSource(WhiteMap param) {		
		return sourceMapper.deleteSource(param);
	}
	
	/**
	 * 소스가이드 조회 카운트
	 * @param param
	 * @return
	 */
	public int selectSourceGuideCount(WhiteMap param) {
		return sourceMapper.selectSourceGuideCount(param);	
	}
	
	
	/**
	 * 소스가이드 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectSourceGuideList(WhiteMap param) {		
		return sourceMapper.selectSourceGuideList(param);	
		
	}
}
