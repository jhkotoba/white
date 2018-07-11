package com.ljh.white.source.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.source.mapper.SourceMapper;

@Service("SourceService")
public class SourceService {
	
	@Resource(name = "SourceMapper")
	private SourceMapper sourceMapper;
	
	
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
	public int insertSourceCode(WhiteMap param) {
		return sourceMapper.insertSourceCode(param);
	}

}
