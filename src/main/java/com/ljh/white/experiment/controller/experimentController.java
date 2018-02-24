package com.ljh.white.experiment.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class experimentController {
	
	@RequestMapping(value="/experiment/experimentMain.do")
	public String experimentMain(HttpServletRequest request){
		System.out.println("experimentMain");
		
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "experiment/experimentMain.jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/experiment/exitTimer.do")
	public String exitTime(HttpServletRequest request){
		System.out.println("exitTime");
		
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "experiment/exitTimer.jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/experiment/cssDemo.do")
	public String cssDemo(HttpServletRequest request){
		System.out.println("cssDemo");
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "experiment/cssDemo.jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/experiment/roofTest.do")
	public String roofTest(HttpServletRequest request){
		System.out.println("roofTest");
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "experiment/roofTest.jsp");
		return "white.jsp";
	}
	
}