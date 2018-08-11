package com.ljh.white.main.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ljh.white.common.White;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.main.service.MainService;

@Controller
public class MainController {

	@Resource(name = "MainService")
	private MainService mainService;
	
	//메인페이지
	@RequestMapping(value="/")
	public String white(HttpServletRequest request){			
		return "redirect:/main";
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
	
	//로그인 유저확인
	@ResponseBody
	@RequestMapping(value="/main/loginCheck.ajax")
	public boolean loginCheck(HttpServletRequest request){
		
		WhiteMap param = new WhiteMap();
		
		param.put("userId", request.getParameter("userId"));
		param.put("passwd", request.getParameter("passwd"));		
		return mainService.loginCheck(param);
	}
	
	//로그인
	@RequestMapping(value="/main/login")
	public String login(HttpServletRequest request, Device device){
		
		WhiteMap param = new WhiteMap();
		param.put("userId", request.getParameter("userId"));
		param.put("passwd", request.getParameter("passwd"));
		mainService.login(request, param);
		
		return "redirect:/main";
	}
	
	//화면이동 컨트롤러
	@RequestMapping(value="{navUrl}")
	public String white(HttpServletRequest request, Device device){		
		WhiteMap param = new WhiteMap(request);		
		
		String navUrl = param.getString("navUrl");		
		String sideUrl = param.getString("sideUrl");				
		
		request.setAttribute("navUrl", navUrl);
		request.setAttribute("sideUrl", sideUrl);		
		request.setAttribute("sectionPage", navUrl.replace("/", "")+sideUrl+".jsp");
		return White.device(device)+"/white.jsp";
	}
	
}
