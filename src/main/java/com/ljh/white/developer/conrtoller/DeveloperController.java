package com.ljh.white.developer.conrtoller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.collection.WhiteMap;

@Controller
public class DeveloperController {
	
	private static Logger logger = LogManager.getLogger(DeveloperController.class);

	//개발자 페이지
	@RequestMapping(value="/developer")
	public String developer(HttpServletRequest request, HttpServletResponse response) throws IOException{
		logger.debug("developer start");
		
		WhiteMap auth = (WhiteMap)request.getSession(false).getAttribute("authority");		
		if(auth.getInt("developer")==0) {
			response.sendRedirect(request.getRequestURI()+"/main");
		}
		
		return "developer/developer.jsp";
		
	}
}
