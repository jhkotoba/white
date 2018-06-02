package com.ljh.white.source.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.White;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.source.service.SourceService;


@Controller
public class SourceController {
			
	private static Logger logger = LogManager.getLogger(SourceController.class);
	
	@Resource(name = "SourceService")
	private SourceService sourceService;
	
	@RequestMapping(value="/source")
	public String source(HttpServletRequest request, Device device){
		logger.debug("source Start");
		
		WhiteMap param = new WhiteMap(request);		
			
		String navUrl = param.getString("navUrl");
		String sideUrl = param.getString("sideUrl");
		
		request.setAttribute("navUrl", navUrl);
		request.setAttribute("sideUrl", sideUrl);
		
		request.setAttribute("sectionPage", navUrl.replace("/", "")+sideUrl+".jsp");
		return White.device(device)+"/white.jsp";
	}
	
	@RequestMapping(value="/source/selectSourceCodeList.ajax" )
	public String selectSourceCodeList(HttpServletRequest request){
		logger.debug("selectSourceCodeList Start");
		
		WhiteMap param = new WhiteMap(request);
		int totalCnt = sourceService.selectSourceCodeCount(param);
		
		JSONObject result = new JSONObject();		
		result.put("totalCnt", totalCnt);
		result.put("list", new JSONArray(sourceService.selectSourceCodeList(param)));
		request.setAttribute("result", result);	
		
		return "result.jsp";
	}
}
