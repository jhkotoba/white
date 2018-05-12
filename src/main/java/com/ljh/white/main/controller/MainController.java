package com.ljh.white.main.controller;


import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.White;

@Controller
public class MainController {
	
	private static Logger logger = LogManager.getLogger(MainController.class);

	//메인페이지
	@RequestMapping(value="/")
	public String white(HttpServletRequest request){		
		logger.debug("white start");
		return "redirect:main";
	}

	//메인페이지
	@RequestMapping(value="/main")
	public String main(HttpServletRequest request, Device device){
		logger.debug("main start");
		request.setAttribute("sectionPage", "main/main.jsp");		
		return White.device(device)+"/white.jsp";
	}
}
