package com.ljh.white.main.controller;

import java.io.UnsupportedEncodingException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
	
	//로그아웃
	@RequestMapping(value = "/main/logout")
	public String logout(HttpServletRequest request){
		//세션정보 삭제
		HttpSession session = request.getSession();
		session.removeAttribute("userId");
		session.removeAttribute("userSeq");
		session.removeAttribute("authority");
		session.removeAttribute("navList");
		session.removeAttribute("sideList");
		session.invalidate();
		
		return "redirect:/main";
	}
	
	//가입
	@RequestMapping(value = "/main/join")
	public String signUp(HttpServletRequest request, Device device){	
		if(request.getSession(false).getAttribute("userId") == null) {
			request.setAttribute("sectionPage", "main/join.jsp");		
			return White.device(device)+"/white.jsp";
		}else {
			return "redirect:/main";
		}
	}

	//화면이동 컨트롤러
	@RequestMapping(value="{navUrl}")
	public String white(HttpServletRequest request, Device device) throws UnsupportedEncodingException{		
		WhiteMap param = new WhiteMap(request);	
		
		String navUrl = param.getString("navUrl");
		String sideUrl = param.getString("sideUrl");	
		
		request.setCharacterEncoding("UTF-8");
		
		request.setAttribute("navUrl", navUrl);
		request.setAttribute("sideUrl", sideUrl);
		request.setAttribute("navNm", param.getString("navNm"));
		request.setAttribute("sideNm", param.getString("sideNm"));
		
		request.setAttribute("sectionPage", navUrl.replace("/", "")+sideUrl+".jsp");
		return White.device(device)+"/white.jsp";
	}
	
}
