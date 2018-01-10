package com.ljh.white.testing.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.utility.WhiteDate;




@Controller
public class TestingController {
	
	@RequestMapping(value="/testingPage.do")
	public String testingPage(HttpServletRequest request, HttpServletResponse response){
		System.out.println("## TestingController.testingPage ##");
		
		//WhiteDate.dateCalculate TEST
		System.out.println("2017-01-01 01:00:00");		
		System.out.println(WhiteDate.dateCalculate("2017-01-01 01:00:00", 1000));

		return "testing.jsp";		
	}
}
