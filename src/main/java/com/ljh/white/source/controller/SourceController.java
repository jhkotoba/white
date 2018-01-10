package com.ljh.white.source.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SourceController {
			
	@RequestMapping(value="/source.do")
	public String mainInfo(HttpServletRequest request, HttpServletResponse response){
		
		String sectionPage = request.getParameter("sideClick");		
		String userSeq = request.getParameter("userSeq");
		
		if(sectionPage == null) sectionPage = "Main";		
		
		switch(sectionPage){
		case "java" :
			break;
		case "javaScript" :
			break;
		case "jQuery" :
			break;
		}
			
		//page	
		request.setAttribute("sidePage", "source/sourceSide.jsp");		
		request.setAttribute("sectionPage", "source/source"+sectionPage+".jsp");		
		
		return "white.jsp";		
	}
}
