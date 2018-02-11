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
		logger.debug("white start");
		return "redirect:main.do";		
	}

	//메인페이지-info
	@RequestMapping(value="/main.do")
	public String main(HttpServletRequest request, HttpServletResponse response){
		logger.debug("main start");
		
		request.setAttribute("sidePage", null);	
		request.setAttribute("sectionPage", "main/main.jsp");			
		
		return "white.jsp";
	}
}
