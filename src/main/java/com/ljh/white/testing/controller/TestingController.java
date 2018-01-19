package com.ljh.white.testing.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TestingController {
	
	@RequestMapping(value="/testMain.do")
	public String testingPage(){
		return "test/testMain.jsp";		
	}
	
	@RequestMapping(value="/exitTimer.do")
	public String exitTime(){
		return "test/exitTimer.jsp";		
	}
	
	@RequestMapping(value="/cssDemo.do")
	public String cssDemo(){
		return "test/cssDemo.jsp";		
	}
	
}


/*System.out.println("## TestingController.testingPage ##");

//WhiteDate.dateCalculate TEST
System.out.println("2017-01-01 01:00:00");		
System.out.println(WhiteDate.dateCalculate("2017-01-01 01:00:00", 1000));*/