package com.ljh.white.source.controller;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.source.service.SourceService;


@RestController
public class SourceController {
			
	private static Logger logger = LogManager.getLogger(SourceController.class);
	
	@Resource(name = "SourceService")
	private SourceService sourceService;	
	
	@RequestMapping(value="/source/selectSourceList.ajax" )
	public WhiteMap selectSourceList(HttpServletRequest request){
		logger.debug("selectSourceList Start");
		
		WhiteMap param = new WhiteMap(request);		
		
		WhiteMap result = new WhiteMap();
		result.put("itemsCount", sourceService.selectSourceCount(param));
		result.put("list", sourceService.selectSourceList(param));
		
		return result;
	}
	
	@RequestMapping(value="/source/selectSourceDtlView.ajax")
	public WhiteMap selectSourceDtlView(HttpServletRequest request) {
		logger.debug("selectSourceDtlView Start");
		
		WhiteMap param = new WhiteMap(request);
		return sourceService.selectSourceDtlView(param);
		
	}
	
	@RequestMapping(value="/source/insertSource.ajax" )
	public int insertSourceCode(HttpServletRequest request){
		logger.debug("insertSource Start");
		
		WhiteMap param = new WhiteMap(request);
		return sourceService.insertSource(param);
	
	}
	
	@RequestMapping(value="/source/updateSource.ajax" )
	public int updateSource(HttpServletRequest request){
		logger.debug("updateSource Start");
		
		WhiteMap param = new WhiteMap(request);		
		return sourceService.updateSource(param);	
	}
	
	@RequestMapping(value="/source/deleteSource.ajax" )
	public int deleteSource(HttpServletRequest request){
		logger.debug("deleteSource Start");
		
		WhiteMap param = new WhiteMap(request);		
		return sourceService.deleteSource(param);	
	}
	
}
