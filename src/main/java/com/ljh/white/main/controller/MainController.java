package com.ljh.white.main.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
	
	private static Logger logger = LogManager.getLogger(MainController.class);

	//메인페이지
	@RequestMapping(value="/")
	public String white(HttpServletRequest request){		
		return "redirect:mainInfo.do";		
	}

	//메인페이지-info
	@RequestMapping(value="/mainInfo.do")
	public String mainInfo(HttpServletRequest request, HttpServletResponse response){
		//page	
		request.setAttribute("sidePage", "NOPAGE");	
		request.setAttribute("sectionPage", "info/mainInfo.jsp");			
		
		return "white.jsp";
	}
}
