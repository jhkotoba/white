package com.ljh.white.admin.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AdminController {
	
	
	

	//메인페이지-info
	@RequestMapping(value="/adminPage.do")
	public String adminPage(HttpServletRequest request, HttpServletResponse response){
		
			
		
		return null;
	}
}
