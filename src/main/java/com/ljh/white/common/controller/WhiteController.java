package com.ljh.white.common.controller;



import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ljh.white.common.White;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.service.WhiteService;


@Controller
public class WhiteController {
	
	@Resource(name = "WhiteService")
	private WhiteService whiteService;
	
	//메인페이지
	@RequestMapping(value="/")
	public String white(HttpServletRequest request){			
		return "redirect:main";
	}
	
	//테스트 페이지
	@RequestMapping(value="/test")
	public String test(HttpServletRequest request, Device device){
		return White.device(device)+"/test.jsp";
	}

	//메인페이지
	@RequestMapping(value="/main")
	public String main(HttpServletRequest request, Device device){
		
		request.setAttribute("sectionPage", "main/main.jsp");		
		return White.device(device)+"/white.jsp";
	}
	
	@RequestMapping(value= {"/admin", "/board", "/ledgerRe", "/source", "/bookmark"})
	public String white(HttpServletRequest request, Device device){
		
		WhiteMap param = new WhiteMap(request);
		
		String navUrl = param.getString("navUrl");
		String sideUrl = param.getString("sideUrl");		
		
		request.setAttribute("navUrl", navUrl);
		request.setAttribute("sideUrl", sideUrl);		
		request.setAttribute("sectionPage", navUrl.replace("/", "")+sideUrl+".jsp");
		return White.device(device)+"/white.jsp";
	}
	
	@ResponseBody
	@RequestMapping(value="/white/selectCodeList.ajax")
	public List<WhiteMap> code(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		return whiteService.selectCodeList(param);		
	}
  

	

}
