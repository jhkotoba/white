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
	public int selectSourceCodeCount(WhiteMap param) {
		return sourceMapper.selectSourceCodeCount(param);	
	}
	
	/**
	 * 소스게시판 리스트 조회
	 * @param Parma
	 * @return
	 */
	public List<WhiteMap> selectSourceCodeList(WhiteMap param){
		param.put("pagePre", (param.getInt("pageNum")-1)*param.getInt("pageCnt"));
		return sourceMapper.selectSourceCodeList(param);
	}
	
	/**
	 * 소스게시판 상세화면 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectSourceDtlView(WhiteMap param) {
		return sourceMapper.selectSourceDtlView(param);
	}

}
