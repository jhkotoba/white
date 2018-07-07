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
	
	@RequestMapping(value="/source/selectSourceCodeList.ajax" )
	public WhiteMap selectSourceCodeList(HttpServletRequest request){
		logger.debug("selectSourceCodeList Start");
		
		WhiteMap param = new WhiteMap(request);		
		
		WhiteMap result = new WhiteMap();
		result.put("totalCnt", sourceService.selectSourceCodeCount(param));
		result.put("list", sourceService.selectSourceCodeList(param));
		
		return result;
	}
	
	@RequestMapping(value="/source/selectSourceDtlView")
	public WhiteMap selectSourceDtlView(HttpServletRequest request) {
		logger.debug("selectSourceDtlView Start");
		
		WhiteMap param = new WhiteMap(request);
		return sourceService.selectSourceDtlView(param);
		
	}
	
}
