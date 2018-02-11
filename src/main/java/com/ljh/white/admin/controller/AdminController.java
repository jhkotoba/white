package com.ljh.white.admin.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class AdminController {
	
	private static Logger logger = LogManager.getLogger(AdminController.class);

	@RequestMapping(value="/admin/adminMain.do")
	public String adminMain(HttpServletRequest request){
		logger.debug("adminMain Start");
			
		request.setAttribute("sidePage", "admin/adminSide.jsp");		
		request.setAttribute("sectionPage", "admin/adminMain.jsp");
		return "white.jsp";
	}
}
