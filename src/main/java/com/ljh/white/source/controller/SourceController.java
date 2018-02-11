package com.ljh.white.source.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class SourceController {
			
	private static Logger logger = LogManager.getLogger(SourceController.class);
	
	@RequestMapping(value="/source/sourceMain.do")
	public String sourceMain(HttpServletRequest request){
		logger.debug("sourceMain Start");
		
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "source/sourceMain.jsp");
		return "white.jsp";
	}
}
