package com.ljh.white.source.controller;


import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.source.service.SourceService;


@RestController
public class SourceController {
	
	@Resource(name = "SourceService")
	private SourceService sourceService;
	
	/**
	 * 소스코드 목록 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/source/selectSourceList.ajax" )
	public WhiteMap selectSourceList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);
		
		WhiteMap result = new WhiteMap();
		result.put("itemsCount", sourceService.selectSourceCount(param));
		result.put("list", sourceService.selectSourceList(param));
		
		return result;
	}
	
	/**
	 * 소스코드 상세 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/source/selectSourceDtlView.ajax")
	public WhiteMap selectSourceDtlView(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		return sourceService.selectSourceDtlView(param);
		
	}
	
	/**
	 * 소스코드 저장
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/source/insertSource.ajax" )
	public int insertSourceCode(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);
		return sourceService.insertSource(param);
	
	}
	
	/**
	 * 소스코드 수정
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/source/updateSource.ajax" )
	public int updateSource(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);		
		return sourceService.updateSource(param);	
	}
	
	/**
	 * 소스코드 삭제
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/source/deleteSource.ajax" )
	public int deleteSource(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);		
		return sourceService.deleteSource(param);	
	}
	
	/**
	 * 소스가이드 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/source/selectSourceGuideList.ajax" )
	public List<WhiteMap> selectSourceGuideList(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);		
		return sourceService.selectSourceGuideList(param);	
	}
	
}
