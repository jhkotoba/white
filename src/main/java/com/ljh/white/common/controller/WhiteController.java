package com.ljh.white.common.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.service.WhiteService;

/**
 * 공통 컨트롤러
 * @author JeHoon
 *
 */
@Controller
public class WhiteController {
	
	@Resource(name = "WhiteService")
	private WhiteService whiteService;	
	
	@ResponseBody
	@RequestMapping(value="/white/selectCodeList.ajax")
	public List<WhiteMap> code(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return whiteService.selectCodeList(param);		
	}
  

	

}
