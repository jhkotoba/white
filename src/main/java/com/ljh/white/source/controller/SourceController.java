package com.ljh.white.source.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SourceController {
			
	@RequestMapping(value="/source.do")
	public String sourceMain(HttpServletRequest request, HttpServletResponse response){

		return null;
	}
}
