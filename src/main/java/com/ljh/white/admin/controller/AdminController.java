package com.ljh.white.admin.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.collection.WhiteMap;


@Controller
public class AdminController {
	
	private static Logger logger = LogManager.getLogger(AdminController.class);

	@RequestMapping(value="/admin/adminMain.do")
	public String adminMain(HttpServletRequest request){
		logger.debug("adminMain Start");
		
		WhiteMap param = new WhiteMap(request);
		
		String sectionPage = param.getString("move");		
		if("".equals(sectionPage) || sectionPage == null) sectionPage = "Main";
		
		/*switch(sectionPage){
		case "Main" :
			break;
		}*/
		
		request.setAttribute("sidePage", "admin/adminSide.jsp");
		request.setAttribute("sectionPage", "admin/admin"+sectionPage+".jsp");
		return "white.jsp";
	}
}
