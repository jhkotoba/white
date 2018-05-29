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
	 * 소스게시판 리스트 조회
	 * @param Parma
	 * @return
	 */
	public List<WhiteMap> selectSourceCodeList(WhiteMap parma){
		return sourceMapper.selectSourceCodeList(parma);
	}

}
